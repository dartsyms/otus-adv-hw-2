//
//  UIExtensions.swift
//  hwappsecond
//

import SwiftUI

extension UIApplication {
    func endFieldEditing(_ force: Bool) {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
    
    func onUpdate(_ handler: @escaping () -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
        })
    }
}

extension UIColor {
    func add(overlay: UIColor) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = fgA * fgR + (1 - fgA) * bgR
        let g = fgA * fgG + (1 - fgA) * bgG
        let b = fgA * fgB + (1 - fgA) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static func +(lhs: UIColor, rhs: UIColor) -> UIColor {
        return lhs.add(overlay: rhs)
    }
}
