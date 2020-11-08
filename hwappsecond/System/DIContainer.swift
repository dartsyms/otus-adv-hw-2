//
//  DIContainer.swift
//  hwappsecond
//

import Foundation

class DIContainer {
    static func makeDefault() {
        Resolver.shared.register(TagServiceImpl() as TagService)
        Resolver.shared.register(PostServiceImpl() as PostService)
        Resolver.shared.register(UserServiceImpl() as UserService)
        Resolver.shared.register(GeoServiceImpl() as GeoService)
        Resolver.shared.register(CommentServiceImpl() as CommentService)
    }
}
