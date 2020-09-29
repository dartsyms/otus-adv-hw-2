//
//  TagsListViewModel.swift
//  hwappsecond
//
//  Created by sanchez on 22.09.2020.
//

import Foundation
import Combine

enum CharcterInRange {
    case fromAToH
    case fromItoP
    case fromQtoZ
}

final class TagsListViewModel: ObservableObject {
    @Published private(set) var dataSource = [Tag]()
    @Published private(set) var isLoading = false
    @Published private(set) var page: Int = 0
    @Published var switcher: CharcterInRange = .fromAToH {
        didSet { reload() }
    }
    
    var request: AnyCancellable?
    
    func load() {
        guard !isLoading else { return }
        self.isLoading = true
        self.request = nil
        var cancelled = false
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let `self` = self else { return }
            self.request = DefaultAPI.getTags(page: self.page, limit: 10)
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
                    print(list)
                    guard !cancelled else { return }
                    _ = list.compactMap {self.dataSource.append(Tag(title: $0)) }
                    self.page += 1
                })
        }
    }
    
    func reload() {
        self.request?.cancel()
        self.reset()
        self.dataSource.removeAll()
        self.load()
    }
    
    private func reset() {
        self.page = -1
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
