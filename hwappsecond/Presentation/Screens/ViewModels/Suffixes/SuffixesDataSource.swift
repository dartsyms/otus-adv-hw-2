//
//  SuffixesDataSource.swift
//  hwappsecond
//

import Foundation
import Combine

typealias IncomingData = [String]
typealias Suffixes = [String: Int]

public enum SortingType {
    case asc, desc
}

enum PickerState {
    case all, top3s, top5s
}

final class SuffixesDataSource: ObservableObject {
    @Published var suffixes: Suffixes = [String: Int]()
    @Published var tops = [(String, Int)]()
    @Published var term: String = String()
    @Published var switcher: PickerState = .all {
        didSet {
            filterByPicker()
        }
    }
    
    @Published var sortToggle: SortingType = .asc {
        didSet {
            if switcher != .all {
                return
            }
            sortByKeys(type: sortToggle)
            filterByPicker()
        }
    }
    
    var source: IncomingData
    
    private func filterByPicker() {
        if switcher == .top3s {
            getTop(of: 10, charCount: 3)
        }
        if switcher == .top5s {
            getTop(of: 10, charCount: 5)
        }
        if switcher == .all {
            self.sortByKeys(type: sortToggle)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(source: String) {
        self.source = source.components(separatedBy: CharacterSet.alphanumerics.inverted)
        populate()
        setSearch()
    }
    
    func updateSource(data: String) {
        self.source.removeAll()
        self.source = data.components(separatedBy: CharacterSet.alphanumerics.inverted)
        populate()
        sortByValues()
        filterByPicker()
        
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    private func setSearch() {
        $term
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { item -> String? in
                if item.isEmpty {
                    self.suffixes.removeAll()
                    return nil
                }
                return item
            }
            .compactMap { $0 }
            .sink(receiveCompletion: { _ in
            }, receiveValue: { query in
                self.populate()
                let result = self.suffixes.filter { key, value in
                    key.lowercased().starts(with: query.lowercased())
                }
                self.suffixes.removeAll()
                self.suffixes = result
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }).store(in: &cancellables)
    }
    
    private func populate() {
        suffixes.removeAll()
        source.forEach {
            let sequence = SuffixSequence(str: $0)
            for suffix in sequence {
                suffixes[String(suffix)] = (suffixes[String(suffix)] ?? 0) + 1
            }
        }
    }
    
    func getTop(of topCount: Int, charCount: Int) {
        populate()
        let sorted = suffixes
            .sorted(by: { first, second in first.value > second.value })
            .filter({ key, value in key.count == charCount })
            .prefix(topCount)
        tops = Array(sorted)
    }
    
    func sortByKeys(type: SortingType) {
        populate()
        let sorted = type == .asc
            ? suffixes.sorted { lhs, rhs in lhs.key < rhs.key }
            : suffixes.sorted { lhs, rhs in lhs.key > rhs.key }
        suffixes.removeAll()
        for item in sorted {
            suffixes[item.key] = item.value
        }
    }
    
    func sortByValues() {
        suffixes.removeAll()
        populate()
        let sorted = suffixes.sorted { $0.value > $1.value }
        for item in sorted {
            suffixes[item.key] = item.value
        }
    }
}

final class ShareDataUpdate: ObservableObject {
    public let notifier = PassthroughSubject<Bool, Never>()
    var updated: Bool = false {
        willSet {
            notifier.send(updated)
        }
    }
}

