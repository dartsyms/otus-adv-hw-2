//
//  Network.swift
//  hwappsecond
//
//  Created by sanchez on 22.09.2020.
//

import Foundation
import Combine

enum ApiError: Error {
    case unknown(String)
}

extension DefaultAPI {
    class func getTags(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue = DummyAPI.apiResponseQueue) -> Future<[String], Error> {
        return Future<[String], Error> { promise in
            DefaultAPI.tagsCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { tagsData, error in
                guard error == nil else { return promise(.failure(error!)) }
                if let tags = tagsData?.data {
                    promise(.success(tags))
                } else {
                    promise(.failure(ApiError.unknown("Unexpected nil tags value from api")))
                }
            }
        }
    }
    
    class func getUsers(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue = DummyAPI.apiResponseQueue) -> Future<Users, Error> {
        return Future<Users, Error> { promise in
            DefaultAPI.usersCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { usersList, error in
                guard error == nil, let users = usersList else { return promise(.failure(error!)) }
                promise(.success(users))
            }
        }
    }
    
    class func getPosts(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue = DummyAPI.apiResponseQueue) -> Future<Posts, Error> {
        return Future<Posts, Error> { promise in
            DefaultAPI.postsCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { postsList, error in
                guard error == nil, let posts = postsList else { return promise(.failure(error!)) }
                promise(.success(posts))
            }
        }
    }
    
    class func getUserDetails(userId: String, apiResponseQueue: DispatchQueue = DummyAPI.apiResponseQueue) -> Future<User, Error> {
        return Future<User, Error> { promise in
            DefaultAPI.user(userId: userId, apiResponseQueue: apiResponseQueue) { user, error in
                guard error == nil, let user = user else { return promise(.failure(error!)) }
                promise(.success(user))
            }
        }
    }
    
    class func getCommentsForPost(postId: String, page: Int?, limit: Int?, apiResponseQueue: DispatchQueue = DummyAPI.apiResponseQueue) -> Future<Comments, Error> {
        return Future<Comments, Error> { promise in
            DefaultAPI.commentsCollection(postId: postId, page: page, limit: limit, apiResponseQueue: apiResponseQueue) { commentsList, error in
                guard error == nil, let comments = commentsList else { return promise(.failure(error!)) }
                promise(.success(comments))
            }
        }
    }
}
