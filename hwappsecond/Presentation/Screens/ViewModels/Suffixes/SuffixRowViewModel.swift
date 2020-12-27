//
//  SuffixRowViewModel.swift
//  hwappsecond
//

import Foundation

final class SuffixRowViewModel: ObservableObject {
    var key: String
    var value: Int
    
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
}
