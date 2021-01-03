//
//  PostRowViewModel.swift
//  hwappsecond
//

import Foundation
import DummyApiNetworkClient

final class PostRowViewModel: ObservableObject {
    @Published private(set) var post: CachedPost
    
    init(post: CachedPost) {
        self.post = post
    }
    
    func writtenBy(_ author: CachedUser?) -> String {
        guard author != nil else { return "Unknown Author" }
        return "by \(author?.firstName ?? "John") \(author?.lastName ?? "Dough")"
    }
    
    func titled(_ post: CachedPost?) -> String {
        guard let title = post?.text else { return "No title" }
        return title.capitalized
    }
}
