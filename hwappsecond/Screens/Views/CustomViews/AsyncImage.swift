//
//  AsyncImage.swift
//  hwappsecond
//

import SwiftUI
import UIKit

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    
    private let placeholder: Placeholder
    
    private let image: (UIImage) -> Image
    
    private var content: some View {
        VStack {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
    
    init(url: URL, @ViewBuilder placeholder: () -> Placeholder, @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        self.placeholder = placeholder()
        self.image = image
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        content.onAppear {
            loader.load()
        }
    }
}

