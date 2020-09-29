//
//  Collections.swift
//  hwappsecond
//

import Foundation

extension RandomAccessCollection where Self.Element: Identifiable {
    func isLast(_ item: Element) -> Bool {
        guard !isEmpty else { return false }
        guard let startIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else { return false }
        return distance(from: startIndex, to: endIndex) == 1
    }
}
