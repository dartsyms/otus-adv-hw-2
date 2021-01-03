//
//  NetworkDataSource.swift
//  wkhwappsecond WatchKit Extension
//

import SwiftUI
import Combine
import CoreLocation
import DummyApiNetworkClient

final class NetworkDataSource: ObservableObject {
    @Published private(set) var users = [User]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    
    @Published var user: User?
    
    private var request: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    init() { load() }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = self.getUsers(page: self.page, limit: 20, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
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
    
    var userOrigin: String {
        guard let city = user?.location?.city, let country = user?.location?.country else { return "" }
        return "(\(city), \(country))"
    }
    
    var email: String {
        guard let userEmail = user?.email else { return "" }
        return "Email: \(userEmail)"
    }
    
    var phone: String {
        guard let userPhone = user?.phone else { return "" }
        return "Pnone: \(userPhone)"
    }
    
    func loadDetailsFor(_ id: String?) {
        guard id != nil else { return }
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.getUserDetails(userId: id!, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { user in
                    self.user = user
                })
                .store(in: &self.cancellables)
        }
    }
    
    private func getUsers(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue) -> Future<[User], Error> {
        return Future<[User], Error> { promise in
            DefaultAPI.usersCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { usersList, error in
                guard error == nil else { return promise(.failure(error!)) }
                if let users = usersList?.data {
                    promise(.success(users))
                } else {
                    promise(.failure(WSApiError.unknown("Unexpected nil users value from api")))
                }
            }
        }
    }
    
    private func getUserDetails(userId: String, apiResponseQueue: DispatchQueue) -> Future<User, Error> {
        return Future<User, Error> { promise in
            DefaultAPI.user(userId: userId, apiResponseQueue: apiResponseQueue) { user, error in
                guard error == nil, let user = user else { return promise(.failure(error!)) }
                promise(.success(user))
            }
        }
    }
}

public enum WSApiError: Error {
    case unknown(String)
}
