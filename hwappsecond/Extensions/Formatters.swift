//
//  Formatters.swift
//  hwappsecond
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
