//
//  CommentsDataSource.swift
//  hwappsecond
//

import SwiftUI
import Combine
import DummyApiNetworkClient

final class CommentsDataSource: ObservableObject {
    @Injected var commentService: CommentService
    @Published private(set) var comments = [Comment]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    
    var post: Post
    
    var request: AnyCancellable?
    
    init(post: Post) {
        self.post = post
    }
    
    func loadCommentsFor(_ postId: String) {
        guard !isLoading else { return }
        self.isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = self.commentService.getCommentsForPost(postId: postId, page: self.page, limit: 20, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
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
                }, receiveValue: { comments in
                    var data = [Comment]()
                    print(comments)
                    _ = comments.compactMap {
                        let comment = Comment(id: $0.id, message: $0.message, owner: $0.owner, publishDate: $0.publishDate)
                        data.append(comment)
                    }
                    self.comments = data
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.request?.cancel()
        self.comments.removeAll()
        self.request = nil
    }
}
