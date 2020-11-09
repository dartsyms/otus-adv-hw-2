//
//  Appearance.swift
//  hwappsecond
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    var imageCache: ImageCache {
        get {
            self[ImageCacheKey.self]
        }
        set {
            self[ImageCacheKey.self] = newValue
        }
    }
}


