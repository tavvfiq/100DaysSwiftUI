//
//  ConsolidationVApp.swift
//  ConsolidationV
//
//  Created by Taufiq Widi on 24/03/21.
//

import SwiftUI

@main
struct ConsolidationVApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
