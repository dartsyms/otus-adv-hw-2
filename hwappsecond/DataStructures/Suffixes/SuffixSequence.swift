//
//  SuffixSequence.swift
//  hwappsecond
//

import Foundation

struct SuffixSequence: Sequence {
    let str: String
    
    func makeIterator() -> SuffixIterator {
        return SuffixIterator(item: str)
    }
}
