//
//  HistoryViewModel.swift
//  hwappsecond
//

import Foundation
import Combine
import CoreData

final class HistoryViewModel: ObservableObject {
    @Published var timesDictForSuffixes = [String: Double]()
    @Published var timesDict = [String: Double]()
    
    var suffixesManipulator = SwiftSuffixesManipulator()
    
    let scheduler = JobSheduler()
    
    func suffixesCreationTest() {
        _ = suffixesManipulator.dbItems.map { item in
            guard let src = item.content, let id = item.id else { return }
            let queue = JobQueue(operations: [{
                _ = self.suffixesManipulator.createSuffixes(from: src)
                }])
            scheduler.addJobTo(queue: queue, with: id.uuidString)
        }
        
        scheduler.start() {
            let testResult = self.scheduler.getStats()
            let testTime = self.scheduler.workInterval
            self.suffixesManipulator.dbItems.forEach { item in
                if let key = item.id?.uuidString, let total = testTime {
                    let spentTime = total * (testResult?[key] ?? 0)
                    self.timesDictForSuffixes[key] = spentTime
                }
            }
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func dataStructuresCreationTest(for size: Int, and source: String = "") {
        let arrayQueue = JobQueue(operations: [{ _ = SwiftArrayManipulator().setupWithObjectCount(size) }])
        scheduler.addJobTo(queue: arrayQueue, with: "Array")
        
        let setQueue = JobQueue(operations: [{ _ = SwiftSetManipulator().setupWithObjectCount(size) }])
        scheduler.addJobTo(queue: setQueue, with: "Set")
        
        let dictionaryQueue = JobQueue(operations: [{ _ = SwiftDictionaryManipulator().setupWithEntryCount(size) }])
        scheduler.addJobTo(queue: dictionaryQueue, with: "Dictionary")
        
        let suffixQueue = JobQueue(operations: [{ _ = self.suffixesManipulator.createSuffixes(from: source) }])
        scheduler.addJobTo(queue: suffixQueue, with: "SuffixArray")
        
        scheduler.start() {
            let testResult = self.scheduler.getStats()
            if let total = self.scheduler.workInterval {
                self.timesDict["Array"] = total * (testResult?["Array"] ?? 0)
                self.timesDict["Set"] = total * (testResult?["Set"] ?? 0)
                self.timesDict["Dictionary"] = total * (testResult?["Dictionary"] ?? 0)
                self.timesDict["SuffixArray"] = total * (testResult?["SuffixArray"] ?? 0)
            }
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
