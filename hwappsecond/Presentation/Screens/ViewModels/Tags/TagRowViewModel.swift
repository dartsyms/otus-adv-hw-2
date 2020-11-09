//
//  TagRowViewModel.swift
//  hwappsecond
//

import Foundation
import DummyApiNetworkClient

final class TagRowViewModel: ObservableObject {
    @Published private(set) var tag: Tag
    
    init(tag: Tag) {
        self.tag = tag
    }
}
