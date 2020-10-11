//
//  ImageLoader.swift
//  hwappsecond
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var request: AnyCancellable?
    private let url: URL
    private var cache: ImageCache?
    private(set) var isLoading = false
    
    private static let processingQueue = DispatchQueue(label: "load-image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        
        if let image = cache?[url] {
            self.image = image
            return
        }
        
        request = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: Self.processingQueue)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onLoad() },
                receiveOutput: { [weak self] in self?.save($0) },
                receiveCompletion: { [weak self] _ in self?.onFinish() },
                receiveCancel: { [weak self] in self?.onFinish() })
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.image = $0
            }
    }
    
    func cancel() {
        request?.cancel()
    }
    
    private func save(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
    
    private func onLoad() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
}
