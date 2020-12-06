//
//  bathymetryApp.swift
//  bathymetry
//
//  Created by Kenzan Hase on 12/6/20.
//

import SwiftUI

@main
struct bathymetryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
