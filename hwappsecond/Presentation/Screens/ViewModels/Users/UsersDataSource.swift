//
//  UsersDataSource.swift
//  hwappsecond
//

import SwiftUI
import Combine

final class UsersDataSource: ObservableObject {
    @Published private(set) var users = [User]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    @Injected var userService: UserService
    
    var request: AnyCancellable?
    
    init() { load() }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = self.userService.getUsers(page: self.page, limit: 20, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .handleEvents(receiveSubscription: { subscription in
                    print("Subscription: \(subscription.combineIdentifier)")
                }, receiveOutput: { users in
                    print("Users \(users)")
                }, receiveCompletion: { _ in
                    print("Received completion")
                }, receiveCancel: {
                    print("Cancelled")
                }, receiveRequest: { _ in
                    
                })
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { list in
                    print(list)
                    _ = list.compactMap {
                        let user = User(id: $0.id,
                                        title: $0.title,
                                        firstName: $0.firstName,
                                        lastName: $0.lastName,
                                        gender: $0.gender,
                                        email: $0.email,
                                        location: $0.location,
                                        dateOfBirth: $0.dateOfBirth,
                                        registerDate: $0.registerDate,
                                        phone: $0.phone,
                                        picture: $0.picture)
                        self.users.append(user)
                    }
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.request?.cancel()
        self.users.removeAll()
        self.request = nil
    }
}
