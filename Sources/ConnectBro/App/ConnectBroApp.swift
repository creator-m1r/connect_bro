import SwiftUI

@main
struct ConnectBroApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup("Connect Bro") {
            ContentView()
                .environmentObject(state)
                .frame(minWidth: 1100, minHeight: 720)
        }
        .windowResizability(.contentSize)
    }
}
