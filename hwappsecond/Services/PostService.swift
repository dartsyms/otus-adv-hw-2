//
//  PostService.swift
//  hwappsecond
//

import Foundation
import Combine

protocol PostService {
    func getPosts(page: Int?, limit: Int?, apiResponseQueue: DispatchQueue) -> Future<[Post], Error>
    func getPostDetails(postId: String, apiResponseQueue: DispatchQueue) -> Future<Post, Error>
}

final class PostServiceImpl: PostService {
    
    func getPosts(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue) -> Future<[Post], Error> {
        return Future<[Post], Error> { promise in
            DefaultAPI.postsCollection(page: page, limit: limit, apiResponseQueue: apiResponseQueue) { postsList, error in
                guard error == nil else { return promise(.failure(error!)) }
                if let posts = postsList?.data {
                    promise(.success(posts))
                } else {
                    promise(.failure(ApiError.unknown("Unexpected nil users value from api")))
                }
            }
        }
    }
    
    func getPostDetails(postId: String, apiResponseQueue: DispatchQueue = DummyAPIConfig.apiResponseQueue) -> Future<Post, Error> {
        return Future<Post, Error> { promise in
            DefaultAPI.post(postId: postId, apiResponseQueue: apiResponseQueue) { user, error in
                guard error == nil, let user = user else { return promise(.failure(error!)) }
                promise(.success(user))
            }
        }
    }
}
