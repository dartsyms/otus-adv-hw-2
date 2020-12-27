//
//  Profiler.swift
//  hwappsecond
//
//  Created by Ellen Shapiro on 8/2/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

import Foundation

class Profiler {
  class func runClosureForTime(_ closure: (() -> Void)!) -> TimeInterval {
    let startDate = Date()
    closure()
    let endDate = Date()
    return endDate.timeIntervalSince(startDate)
  }
}
