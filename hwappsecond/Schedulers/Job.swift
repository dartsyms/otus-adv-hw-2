//
//  Job.swift
//  hwappsecond
//

import Foundation

enum ItemState {
    case pending, active, finished
}

enum JobError: Error {
    case unknownError
}

class Job {
    var name: String
    var queue: JobQueue
    var state: ItemState
    var duration: TimeInterval?
    
    init(queue: JobQueue, name: String) {
        self.queue = queue
        self.name = name
        self.state = .pending
    }

    open func getWorkDuration() -> Double {
        self.duration != nil ? Double(self.duration!) : 0.0
    }
}
