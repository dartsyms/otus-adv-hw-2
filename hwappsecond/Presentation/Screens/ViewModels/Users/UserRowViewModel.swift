//
//  UserRowViewModel.swift
//  hwappsecond
//

import Foundation


final class UserRowViewModel: ObservableObject {
    @Published private(set) var user: User
    
    init(user: User) {
        self.user = user
    }
    
    var fullName: String {
        return "\(user.firstName ?? "John") \(user.lastName ?? "Dough")"
    }
}