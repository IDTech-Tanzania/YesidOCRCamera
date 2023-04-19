import SwiftUI
import Combine


@main
struct YesIDApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var body: some Scene {
        WindowGroup {
            MainApp()
        }
    }
}

