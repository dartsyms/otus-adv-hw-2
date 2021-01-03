//
//  UserRowViewModel.swift
//  hwappsecond
//

import Foundation
import DummyApiNetworkClient


final class UserRowViewModel: ObservableObject {
    @Published private(set) var user: CachedUser
    
    init(user: CachedUser) {
        self.user = user
    }
    
    var fullName: String {
        return user.name
    }
}
