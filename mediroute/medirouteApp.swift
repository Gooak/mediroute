//
//  medirouteApp.swift
//  mediroute
//
//  Created by 황진우 on 11/14/25.
//

import SwiftUI
import SwiftData

@main
struct medirouteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([DiagnosisHistory.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
