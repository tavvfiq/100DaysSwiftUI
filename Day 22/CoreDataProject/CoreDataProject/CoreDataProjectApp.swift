//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Taufiq Widi on 23/03/21.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
