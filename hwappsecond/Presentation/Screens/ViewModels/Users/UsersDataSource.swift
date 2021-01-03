//
//  UsersDataSource.swift
//  hwappsecond
//

import SwiftUI
import Combine
import DummyApiNetworkClient
import RealmSwift

final class UsersDataSource: ObservableObject {
    @Published private(set) var cachedUsers = [CachedUser]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    @Injected var userService: UserService
    
    let usersQueue = DispatchQueue(label: "thread-safe-userobj", attributes: .concurrent)
    private var token: NotificationToken?
    var isEnded: Bool = false
    var request: AnyCancellable?
    
    lazy var readOnlyRealm: Realm? = {
        return RealmProvider.readOnly.realm
    }()
    var writableRealm: Realm? = {
        return RealmProvider.writable.realm
    }()

    init() {
        loadCached()
    }
    
    deinit {
        token?.invalidate()
    }
    
    func loadCached() {
        usersQueue.sync {
            if let realm = readOnlyRealm {
                let results = CachedUser.all(in: realm)
                token = results.observe { [weak self] changes in
                    guard let `self` = self else { return }
                    switch changes {
                    case .initial:
                        Array(results).forEach { item in
                            if !self.cachedUsers.map({ $0.userId }).contains(item.userId) {
                                self.cachedUsers.append(item)
                            }
                        }
                    case .update(_, _, _, _):
                        Array(CachedUser.all(in: realm)).forEach { item in
                            if !self.cachedUsers.map({ $0.userId }).contains(item.userId) {
                                self.cachedUsers.append(item)
                            }
                        }
                    case .error(let error):
                        let loadError = error as NSError
                        print("Load users from realm error: \(loadError.localizedDescription)")
                    }
                }
            }
        }
        load()
    }
    
    func load() {
        guard !isLoading && !isEnded else { return }
        self.isLoading = true
        
        usersQueue.async(flags: .barrier) { [weak self] in
            guard let `self` = self else { return }
            self.request = self.userService.getUsers(page: self.page, limit: 20, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { list in
                    self.isEnded = list.isEmpty
                    list.forEach { user in
                        let res = self.toCachedUser(from: user)
                        if !self.cachedUsers.compactMap({ $0.userId }).contains(res.userId) {
                            if let realm = self.writableRealm {
                                do {
                                    try realm.write {
                                        realm.add(res, update: .modified)
                                    }
                                } catch {
                                    print("Error saving users")
                                }
                            }
                        }
                    }
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.request?.cancel()
        self.request = nil
    }
    
    private func toCachedUser(from user: DummyApiNetworkClient.User) -> CachedUser {
        let location = CachedLocation(street: user.location?.street, city: user.location?.city,
                                      state: user.location?.state, country: user.location?.country, timezone: user.location?.timezone)
        return CachedUser(userId: user.id, title: user.title?.rawValue, firstName: user.firstName, lastName: user.lastName,
                          gender: user.gender?.rawValue, email: user.email, location: location, dateOfBirth: user.dateOfBirth,
                          registerDate: user.registerDate, phone: user.phone, picture: user.picture)
    }
}
