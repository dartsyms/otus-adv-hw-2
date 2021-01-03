//
//  PostsDataSource.swift
//  hwappsecond
//

import SwiftUI
import Combine
import DummyApiNetworkClient
import RealmSwift

final class PostsDataSource: ObservableObject {
    @Injected var postService: PostService
    @Published var cachedPosts = [CachedPost]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    
    let postsQueue = DispatchQueue(label: "thread-safe-postobj", attributes: .concurrent)
    private var token: NotificationToken?
    var isEnded: Bool = false
    var request: AnyCancellable?
    
    lazy var readOnlyRealm: Realm? = {
        return RealmProvider.readOnly.realm
    }()
    var writableRealm: Realm? = {
        return RealmProvider.writable.realm
    }()
    
    init() {
        loadCached()
    }
    
    deinit {
        token?.invalidate()
    }
    
    func loadCached() {
        postsQueue.sync {
            if let realm = readOnlyRealm {
                let results = CachedPost.all(in: realm)
                token = results.observe { [weak self] changes in
                    guard let `self` = self else { return }
                    switch changes {
                    case .initial:
                        Array(results).forEach { item in
                            if !self.cachedPosts.map({ $0.postId }).contains(item.postId) {
                                self.cachedPosts.append(item)
                            }
                        }
                    case .update(let upds, _, _, _):
                        Array(upds).forEach { item in
                            if !self.cachedPosts.map({ $0.postId }).contains(item.postId) {
                                self.cachedPosts.append(item)
                            }
                        }
                    case .error(let error):
                        let loadError = error as NSError
                        print("Load posts from realm error: \(loadError.localizedDescription)")
                    }
                }
            }
        }
        load()
    }
    
    func load() {
        guard !isLoading && !isEnded else { return }
        self.isLoading = true
        
        postsQueue.async(flags: .barrier) { [weak self] in
            guard let `self` = self else { return }
            self.request = self.postService.getPosts(page: self.page, limit: 10, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { posts in
                    self.isEnded = posts.isEmpty
                    posts.forEach { post in
                        let res = self.toCachedPost(from: post)
                        
                        if !self.cachedPosts.compactMap({ $0.postId }).contains(res.postId) {
                            if let realm = self.writableRealm {
                                do {
                                    try realm.write {
                                        realm.add(res, update: .modified)
                                    }
                                } catch {
                                    print("Error saving posts")
                                }
                            }
                        }
                    }
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.request?.cancel()
        self.request = nil
    }
    
    private func toCachedPost(from post: Post) -> CachedPost {
        let location = CachedLocation(street: post.owner?.location?.street, city: post.owner?.location?.city, state: post.owner?.location?.state,
                                      country: post.owner?.location?.country, timezone: post.owner?.location?.timezone)
        let owner = CachedUser(userId: post.owner?.id, title: post.owner?.title?.rawValue, firstName: post.owner?.firstName, lastName: post.owner?.lastName,
                               gender: post.owner?.gender?.rawValue, email: post.owner?.email, location: location, dateOfBirth: post.owner?.dateOfBirth,
                               registerDate: post.owner?.registerDate, phone: post.owner?.phone, picture: post.owner?.picture)
        var tags = [CachedTag]()
        _ = post.tags?.compactMap { elem in tags.append(CachedTag(title: elem))}
        return CachedPost(postId: post.id, text: post.text, image: post.image, likes: post.likes, link: post.link, tags: tags, publishDate: post.publishDate, owner: owner)
    }
}
