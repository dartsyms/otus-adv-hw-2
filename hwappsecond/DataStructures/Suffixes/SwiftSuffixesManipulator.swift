//
//  SwiftSuffixesManipulator.swift
//  hwappsecond
//

import Foundation
import CoreData

open class SwiftSuffixesManipulator: SuffixesManipulator {
    var dataSource = SuffixesDataSource(source: "")
    var suffixes = [String: Int]()
    var numOfThreeLettersStringsToFind: Int = 10
    var dbItems = [Item]()
    
    init() {
        retrieveFromDB()
    }
    
    private func retrieveFromDB() {
        let context = PersistenceController.shared.container.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        let objects = try? context.fetch(request) as? [Item]
        objects?.forEach { dbItems.append($0) }
        print("Fetched \(objects?.count ?? 0) objects")
        if let source = objects?.randomElement()?.content {
            let dataSource = SuffixesDataSource(source: source)
            dataSource.suffixes.forEach {
                self.suffixes[$0.key] = $0.value
            }
        }
    }
    
    func createSuffixes(from source: String) -> TimeInterval {
        return Profiler.runClosureForTime() {
            let dataSource = SuffixesDataSource(source: source)
            dataSource.suffixes.forEach {
                self.suffixes[$0.key] = $0.value
            }
        }
    }
    
    func createSuffixesFromDB() -> TimeInterval {
        return Profiler.runClosureForTime() {
            self.retrieveFromDB()
        }
    }
    
    func sortSuffixesByKeys() -> TimeInterval {
        retrieveFromDB()
        return Profiler.runClosureForTime() {
            self.dataSource.sortByKeys(type: .asc)
        }
    }
    
    func sortSuffixesByValues() -> TimeInterval {
        retrieveFromDB()
        return Profiler.runClosureForTime() {
            self.dataSource.sortByValues()
        }
    }
    
    func suffixesAreNotEmpty() -> Bool {
        retrieveFromDB()
        return suffixes.count != 0
    }
    
    func lookupBy10RandThreeLettersSeq() -> TimeInterval {
        var threeLettersSeqArray = [String]()
        for _ in 0...9 {
            threeLettersSeqArray.append(StringGenerator().generateRandomString(3))
        }
        
        retrieveFromDB()
        
        return Profiler.runClosureForTime() {
            for threeLettersSeq in threeLettersSeqArray {
                let _ = self.suffixes.map({$0.key}).contains(threeLettersSeq)
            }
        }
    }
    
    func lookupForRequiredSubstrings() -> TimeInterval{
        var threeLettersSeqArray = [String]()
        
        for _ in 0...numOfThreeLettersStringsToFind {
            threeLettersSeqArray.append(StringGenerator().generateRandomString(3))
        }
        
        retrieveFromDB()
        
        return Profiler.runClosureForTime() {
            for threeLettersSeq in threeLettersSeqArray {
                let _ = self.suffixes.map({ $0.key }).contains(threeLettersSeq)
            }
        }
    }
}
