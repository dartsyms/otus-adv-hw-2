//
//  ModelExtensions.swift
//  hwappsecond
//

import Foundation

extension User: Identifiable {}

extension Post: Identifiable {
    public var id: String {
       UUID().uuidString
    }
}

extension Comment: Identifiable {}

extension Tag: Identifiable {
    public var id: String {
        title ?? UUID().uuidString
    }
}
