//
//  DIContainer.swift
//  hwappsecond
//

import Foundation
import DummyApiNetworkClient

class DIContainer {
    static func makeDefault() {
        DummyAPIConfig.customHeaders.updateValue("5f7c2dcc582b4b0e578d238d", forKey: "app-id")
        Resolver.shared.register(TagServiceImpl() as TagService)
        Resolver.shared.register(PostServiceImpl() as PostService)
        Resolver.shared.register(UserServiceImpl() as UserService)
        Resolver.shared.register(GeoServiceImpl() as GeoService)
        Resolver.shared.register(CommentServiceImpl() as CommentService)
    }
}
