//
//  TemporaryImageCache.swift
//  hwappsecond
//

import UIKit
import SwiftUI

// TODO: persistence between launches

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let storage = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get {
            storage.object(forKey: key as NSURL)
        }
        set {
            newValue == nil ? storage.removeObject(forKey: key as NSURL) : storage.setObject(newValue!, forKey: key as NSURL)
        }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

