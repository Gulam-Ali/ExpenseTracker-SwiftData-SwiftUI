//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Gulam Ali on 09/07/24.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {
    
    let container: ModelContainer = {
        let schema = Schema([ExpenseModel.self])
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        //.modelContainer(for: [ExpenseModel.self])
    }
}
