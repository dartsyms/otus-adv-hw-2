//
//  CommentService.swift
//  hwappsecond
//

import Foundation
import Combine

protocol CommentService {
    func getCommentsForPost(postId: String, page: Int?, limit: Int?, apiResponseQueue: DispatchQueue) -> Future<[Comment], Error>
}

final class CommentServiceImpl: CommentService {

    func getCommentsForPost(postId: String, page: Int?, limit: Int?, apiResponseQueue: DispatchQueue) -> Future<[Comment], Error> {
        return Future<[Comment], Error> { promise in
            DefaultAPI.commentsCollection(postId: postId, page: page, limit: limit, apiResponseQueue: apiResponseQueue) { commentsList, error in
                guard error == nil else { return promise(.failure(error!)) }
                if let comments = commentsList?.data {
                    promise(.success(comments))
                } else {
                    promise(.failure(ApiError.unknown("Unexpected nil users value from api")))
                }
            }
        }
    }
}
