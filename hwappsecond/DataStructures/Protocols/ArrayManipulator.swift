//
//  ArrayManipulator.swift
//  hwappsecond
//

import Foundation

protocol ArrayManipulator {
  func arrayHasObjects() -> Bool
  func setupWithObjectCount(_ count: Int) -> TimeInterval
  func insertNewObjectAtBeginning() -> TimeInterval
  func insertNewObjectInMiddle() -> TimeInterval
  func addNewObjectAtEnd() -> TimeInterval
  func removeFirstObject() -> TimeInterval
  func removeMiddleObject() -> TimeInterval
  func removeLastObject() -> TimeInterval
  func lookupByIndex() -> TimeInterval
  func lookupByObject() -> TimeInterval
}
