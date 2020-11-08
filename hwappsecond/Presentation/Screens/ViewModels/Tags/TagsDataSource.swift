//
//  TagsDataSource.swift
//  hwappsecond
//

import Foundation
import Combine

enum CharacterInRange {
    case fromAToH
    case fromItoP
    case fromQtoZ
}

final class TagsDataSource: ObservableObject {
    @Injected var tagService: TagService
    @Published private(set) var tags = [Tag]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    @Published var switcher: CharacterInRange = .fromAToH {
        didSet {
            reload()
        }
    }
    
    var request: AnyCancellable?
    
    init() { load() }
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        self.request = nil
        var cancelled = false
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = self.tagService.getTags(page: self.page, limit: 20, apiResponseQueue: DummyAPIConfig.apiResponseQueue)
                .receive(on: RunLoop.main)
                .handleEvents(receiveSubscription: { subscription in
                    print("Subscription: \(subscription.combineIdentifier)")
                }, receiveOutput: { tags in
                    print("Tags: \(tags)")
                }, receiveCompletion: { _ in
                    print("Received completion")
                }, receiveCancel: {
                    print("Cancelled")
                    cancelled = true
                }, receiveRequest: { _ in
                    
                })
                .sink(receiveCompletion: { completion in
                    guard !cancelled else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error)
                    }
                    self.isLoading = false
                }, receiveValue: { list in
                    guard !cancelled else { return }
                    _ = list
                        .filter { $0.first != nil ? self.range.contains($0.uppercased().first!) : false }
                        .compactMap { self.tags.append(Tag(title: $0)) }
                    self.tags.removeDuplicates()
                    self.page += 1
                })
        }
    }
    
    func cancel() {
        self.isLoading = false
        self.request?.cancel()
        self.tags.removeAll()
        self.request = nil
    }
    
    func reload() {
        self.isLoading = false
        self.request?.cancel()
        self.reset()
        self.tags.removeAll()
        self.load()
    }
    
    private func reset() {
        self.page = 0
        self.isLoading = false
    }
    
    private var range: [Character] {
        switch self.switcher {
        case .fromAToH:
            return rangeToArray("A"..."H")
        case .fromItoP:
            return rangeToArray("I"..."P")
        case .fromQtoZ:
            return rangeToArray("Q"..."Z")
        }
    }

    private var searchedSymbols: [Character] {
        return range.map(Character.init)
    }

    private func rangeToArray(_ range: ClosedRange<Character>) -> [Character] {
        let unicodeScalarRange: ClosedRange<Character> = range
        let unicodeScalarValueRange = unicodeScalarRange.lowerBound.unicodeScalars[unicodeScalarRange.lowerBound.unicodeScalars.startIndex].value...unicodeScalarRange.upperBound.unicodeScalars[unicodeScalarRange.lowerBound.unicodeScalars.startIndex].value
        let unicodeScalarArray = unicodeScalarValueRange.compactMap(Unicode.Scalar.init)
        return unicodeScalarArray.map(Character.init)
    }
}
