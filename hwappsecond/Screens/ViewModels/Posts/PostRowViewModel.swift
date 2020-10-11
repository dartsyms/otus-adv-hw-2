//
//  PostRowViewModel.swift
//  hwappsecond
//

import Foundation

final class PostRowViewModel: ObservableObject {
    @Published private(set) var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    func writtenBy(_ author: User?) -> String {
        guard author != nil else { return "Unknown Author" }
        return "by \(author?.firstName ?? "John") \(author?.lastName ?? "Dough")"
    }
    
    func titled(_ post: Post?) -> String {
        guard let title = post?.text else { return "No title" }
        return title.capitalized
    }
}
