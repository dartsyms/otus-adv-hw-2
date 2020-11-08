//
//  hwappsecondApp.swift
//  hwappsecond
//

import SwiftUI

@main
struct hwappsecondApp: App {
    
    init() {
        DIContainer.makeDefault()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
