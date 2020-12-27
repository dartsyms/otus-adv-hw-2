//
//  JobQueue.swift
//  hwappsecond
//

import Foundation

typealias JobOperation = () -> ()
typealias HandlerWithResult = (_ result: Result<Any, Error>) -> ()

class JobQueue {
    let operations: [JobOperation]
    private var group: DispatchGroup
    var handler: HandlerWithResult? = nil
    private var startedAt: Date?
    
    init(operations: [JobOperation]) {
        self.group = DispatchGroup()
        self.operations = operations
        self.operations.forEach { _ in self.group.enter() }
        configureNotify()
    }
    
    private func configureNotify() {
        self.group.notify(queue: .main) {
            if let startTime = self.startedAt {
                let interval = Date().timeIntervalSince1970 - startTime.timeIntervalSince1970
                self.handler?( .success(interval))
            } else {
                self.handler?(.failure("Job starting error" as! Error) )
            }
        }
    }
    
    func run(handler: @escaping HandlerWithResult) {
        self.handler = handler
        self.startedAt = Date()
         
        operations.forEach { op in
            DispatchQueue.global(qos: .userInitiated).async {
                defer { self.group.leave() }
                op()
            }
        }
    }
}
