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
}
