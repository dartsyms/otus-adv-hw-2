//
//  TagService.swift
//  hwappsecond
//

import Foundation
import Combine
import DummyApiNetworkClient

protocol TagService {
    func getTags(page: Int?, limit: Int?, apiResponseQueue: DispatchQueue) -> Future<[String], Error>
}

final class TagServiceImpl: TagService {
    
    func getTags(page: Int? = nil, limit: Int? = nil, apiResponseQueue: DispatchQueue) -> Future<[String], Error> {
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
}
