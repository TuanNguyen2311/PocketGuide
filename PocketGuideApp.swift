// MARK: - PocketGuideApp.swift

import SwiftUI

@main
struct PocketGuideApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(nil) // Respect system setting
        }
    }
}
