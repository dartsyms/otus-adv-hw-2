//
//  SuffixesManipulator.swift
//  hwappsecond
//

import Foundation

protocol SuffixesManipulator {
    func suffixesAreNotEmpty() -> Bool
    func createSuffixes(from source: String) -> TimeInterval
    func createSuffixesFromDB() -> TimeInterval
    func sortSuffixesByKeys() -> TimeInterval
    func sortSuffixesByValues() -> TimeInterval
    func lookupBy10RandThreeLettersSeq() -> TimeInterval
    func lookupForRequiredSubstrings() -> TimeInterval
}
