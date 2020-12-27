//
//  hwappsecondApp.swift
//  hwappsecond
//

import SwiftUI

@main
struct hwappsecondApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        DIContainer.makeDefault()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
