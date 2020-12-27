//
//  SetManipulator.swift
//  hwappsecond
//

import Foundation

protocol SetManipulator {
  func setHasObjects() -> Bool
  func setupWithObjectCount(_ objectCount: Int) -> TimeInterval
  func add1Object() -> TimeInterval
  func add5Objects() -> TimeInterval
  func add10Objects() -> TimeInterval
  func remove1Object() -> TimeInterval
  func remove5Objects() -> TimeInterval
  func remove10Objects() -> TimeInterval
  func lookup1Object() -> TimeInterval
  func lookup10Objects() -> TimeInterval
}
