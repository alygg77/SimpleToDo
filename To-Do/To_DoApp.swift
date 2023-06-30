//
//  To_DoApp.swift
//  To-Do
//
//  Created by Vladimir on 6/23/23.
//

import SwiftUI

@main
struct To_DoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
