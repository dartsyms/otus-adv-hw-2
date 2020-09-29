//
//  CustomNavigationViewModel.swift
//  hwappsecond
//

import SwiftUI
import Combine

struct Screen: Identifiable, Equatable {
    let id: String
    let next: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
}

enum CustomTransition {
    case none
    case custom(AnyTransition, AnyTransition)
}

enum CustomNavigationType {
    case push, pop
}

enum PopDestination {
    case prev, root
}

final class CustomNavigationViewModel: ObservableObject {
    @Published var currentScreen: Screen?
    private struct ScreenStack {
        private var screens = [Screen]()
        
        func top() -> Screen? {
            screens.last
        }
        
        mutating func push(_ s: Screen) {
            screens.append(s)
        }
        
        @discardableResult
        mutating func pop() -> Screen? {
            screens.popLast()
        }
        
        mutating func popToRoot() {
            screens.removeAll()
        }
    }
    
    private let easing: Animation
    var navigationType = CustomNavigationType.push
    
    private var screenStack = ScreenStack() {
        didSet {
            currentScreen = screenStack.top()
        }
    }
    
    init(easing: Animation) {
        self.easing = easing
    }
    
    func push<S: View>(_ screenView: S) {
        withAnimation(easing) {
            navigationType = .push
            let screen = Screen(id: UUID().uuidString, next: AnyView(screenView))
            screenStack.push(screen)
        }
    }
    
    func pop(to: PopDestination = .prev) {
        withAnimation(easing) {
            navigationType = .pop
            switch to {
            case .prev:
                screenStack.pop()
            case .root:
                screenStack.popToRoot()
            }
        }
    }
    
}
