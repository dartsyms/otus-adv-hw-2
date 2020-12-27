//
//  DictionaryManipulator.swift
//  hwappsecond
//

import Foundation

protocol DictionaryManipulator {
  func dictHasEntries() -> Bool
  func setupWithEntryCount(_ count: Int) -> TimeInterval
  func add1Entry() -> TimeInterval
  func add5Entries() -> TimeInterval
  func add10Entries() -> TimeInterval
  func remove1Entry() -> TimeInterval
  func remove5Entries() -> TimeInterval
  func remove10Entries() -> TimeInterval
  func lookup1EntryTime() -> TimeInterval
  func lookup10EntriesTime() -> TimeInterval
}
