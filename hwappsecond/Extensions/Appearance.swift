//
//  Appearance.swift
//  hwappsecond
//

import Foundation
import SwiftUI

extension UIApplication {
    var keyWindowInConnectedScenes: UIWindow? {
        return windows.first { $0.isKeyWindow }
    }
}

extension UIDevice {
    var hasNotch: Bool {
        return UIApplication.shared.keyWindowInConnectedScenes?.safeAreaInsets.bottom ?? 0 > 0
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).combined(with: opacity)
        let removal = AnyTransition.slide.combined(with: opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var moveBackAndFade: AnyTransition {
        let removal = AnyTransition.slide.combined(with: opacity)
        let insertion = AnyTransition.move(edge: .trailing).combined(with: opacity)
        return .asymmetric(insertion: removal, removal: insertion)
    }
}

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


