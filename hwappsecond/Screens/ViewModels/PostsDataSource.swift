//
//  PostsDataSource.swift
//  hwappsecond
//

import SwiftUI
import Combine

final class PostsDataSource: ObservableObject {
    @Published private(set) var posts = [Post]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    
    var request: AnyCancellable?
    
    init() { load() }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = DefaultAPI.getPosts(page: self.page, limit: 20)
                .receive(on: RunLoop.main)
                .handleEvents(receiveSubscription: { subscription in
                    print("Subscription: \(subscription.combineIdentifier)")
                }, receiveOutput: { posts in
                    print("Posts: \(posts)")
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
                }, receiveValue: { posts in
                    var data = [Post]()
                    print(posts)
                    _ = posts.compactMap {
                        let post = Post(text: $0.text, image: $0.image, likes: $0.likes, link: $0.link, tags: $0.tags, publishDate: $0.publishDate, owner: $0.owner)
                        data.append(post)
                    }
                    self.posts = data
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.request?.cancel()
        self.posts.removeAll()
        self.request = nil
    }
}
