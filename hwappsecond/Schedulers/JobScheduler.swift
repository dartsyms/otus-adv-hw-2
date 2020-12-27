//
//  JobScheduler.swift
//  hwappsecond
//

import Foundation


typealias OnCompleteHandler = () -> ()
typealias ExecutionResult = [String: Double]

class JobSheduler {
    private var state: ItemState = .pending
    private var handler: OnCompleteHandler? = nil
    var workInterval: Double?
    var jobs = [Job]()
    
    init() {}
    
    func addJobTo(queue: JobQueue, with name: String) {
        self.jobs.append(Job(queue: queue, name: name))
        state = state == .finished ? .pending : state
    }
    
    private func stop() {
        let needsToStop = jobs.filter({ $0.state != .finished }).isEmpty
        if needsToStop {
            self.state = .finished
            DispatchQueue.main.async {
                self.handler?()
            }
        }
    }
    
    func getStats() -> ExecutionResult? {
        guard state == .finished else { return nil }
        self.workInterval = jobs.map({ $0.getWorkDuration() }).max()
        guard let maxDuration = self.workInterval, maxDuration != 0 else { return nil }
    
        var result = ExecutionResult.init()
        jobs.forEach {
            result[$0.name] = $0.getWorkDuration() / maxDuration
        }
        return result
    }
    
    func start(handler: @escaping OnCompleteHandler){
        self.handler = handler
        jobs.forEach { jobItem in
            if jobItem.state == .pending {
                jobItem.state = .active
                
                jobItem.queue.run { result in
                    switch result {
                    case .success(let duration):
                        jobItem.state = .finished
                        jobItem.duration = duration as? TimeInterval
                    case .failure(_):
                        jobItem.state = .finished
                        jobItem.duration = 0
                    }
                    self.stop()
                }
            }
        }
    }
}
