//
//  InterRapidisimo_App_iOSApp.swift
//  InterRapidisimo App iOS
//
//  Created by Kenny Yim on 4/03/26.
//

import SwiftUI
import SwiftData

@main
struct InterRapidisimo_App_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DependencyContainer.shared.modelContainer)
    }
}
