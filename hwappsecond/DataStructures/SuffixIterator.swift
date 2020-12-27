//
//  SuffixIterator.swift
//  hwappsecond
//

import Foundation

struct SuffixIterator: IteratorProtocol {
    let item: String
    var last: String.Index
    var offset: String.Index
    
    init(item: String) {
        self.item = item
        self.last = item.endIndex
        self.offset = item.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < last else { return nil }
        let substr: Substring = item[offset..<last]
        item.formIndex(after: &offset)
        return substr
    }
}
