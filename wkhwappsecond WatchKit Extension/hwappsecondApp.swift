//
//  hwappsecondApp.swift
//  wkhwappsecond WatchKit Extension
//

import SwiftUI

@main
struct hwappsecondApp: App {
    
    init() { Initiator.makeDefault() }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
