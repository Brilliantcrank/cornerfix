import SwiftUI
import AppKit

@main
struct CornerFixApp: App {
    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra("CornerFix", systemImage: "square.dashed") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
