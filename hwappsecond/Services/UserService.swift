//
//  UserService.swift
//  hwappsecond
//

import Foundation
import Combine

protocol UserService {
    func getUsers(page: Int?, limit: Int?, apiResponseQueue: DispatchQueue) -> Future<[User], Error>
    func getUserDetails(userId: String, apiResponseQueue: DispatchQueue) -> Future<User, Error>
}

final class UserServiceImpl: UserService {

    func getUsers(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue) -> Future<[User], Error> {
        return Future<[User], Error> { promise in
            DefaultAPI.usersCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { usersList, error in
                guard error == nil else { return promise(.failure(error!)) }
                if let users = usersList?.data {
                    promise(.success(users))
                } else {
                    promise(.failure(ApiError.unknown("Unexpected nil users value from api")))
                }
            }
        }
    }
    
    func getUserDetails(userId: String, apiResponseQueue: DispatchQueue = DummyAPIConfig.apiResponseQueue) -> Future<User, Error> {
        return Future<User, Error> { promise in
            DefaultAPI.user(userId: userId, apiResponseQueue: apiResponseQueue) { user, error in
                guard error == nil, let user = user else { return promise(.failure(error!)) }
                promise(.success(user))
            }
        }
    }
}
