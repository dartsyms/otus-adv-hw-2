//
//  TagRowViewModel.swift
//  hwappsecond
//

import Foundation

final class TagRowViewModel: ObservableObject {
    @Published private(set) var tag: Tag
    
    init(tag: Tag) {
        self.tag = tag
    }
}
