import SwiftUI
import AppKit

struct ContentView: View {
    @State private var windowRadius: Double = Double(CornerRadiusManager.currentWindowRadius() ?? 26)
    @State private var sidebarRadius: Double = Double(CornerRadiusManager.currentSidebarRadius() ?? 19)
    @State private var floatingSidebar: Bool = CornerRadiusManager.currentFloatingSidebar() ?? true
    @State private var statusMessage: String = " "

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("CornerFix")
                    .font(.headline)
                Text("Reverts the window and sidebar corner rounding macOS Tahoe introduced.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Divider()

            HStack {
                Button("Classic (Sequoia-style)") {
                    CornerRadiusManager.applyClassic()
                    refreshValues()
                    statusMessage = "Applied. Quit and reopen other apps to see the change."
                }
                Button("macOS Default") {
                    CornerRadiusManager.resetToSystemDefault()
                    refreshValues()
                    statusMessage = "Reset to system default."
                }
            }

            DisclosureGroup("Advanced") {
                VStack(alignment: .leading, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Window corner radius: \(Int(windowRadius))")
                            .font(.caption)
                        Slider(value: $windowRadius, in: 0...30, step: 1)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Sidebar corner radius: \(Int(sidebarRadius))")
                            .font(.caption)
                        Slider(value: $sidebarRadius, in: 0...25, step: 1)
                    }
                    Toggle("Floating sidebar panel", isOn: $floatingSidebar)
                        .font(.caption)
                    Button("Apply Custom Values") {
                        CornerRadiusManager.applyCustom(
                            windowRadius: Float(windowRadius),
                            sidebarRadius: Float(sidebarRadius),
                            floatingSidebar: floatingSidebar
                        )
                        statusMessage = "Custom values applied. Quit and reopen other apps to see the change."
                    }
                }
                .padding(.top, 4)
            }

            Divider()

            Button("Relaunch Finder") {
                CornerRadiusManager.relaunchFinder()
                statusMessage = "Finder relaunched."
            }

            Text(statusMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(minHeight: 14, alignment: .leading)

            Text("Other apps need a full Quit (⌘Q) and reopen to pick this up. Chromium-based apps (Chrome, Slack, VS Code, Discord) draw their own window frames and are unaffected.")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Button("Quit CornerFix") {
                NSApp.terminate(nil)
            }
        }
        .padding()
        .frame(width: 320)
    }

    private func refreshValues() {
        windowRadius = Double(CornerRadiusManager.currentWindowRadius() ?? 26)
        sidebarRadius = Double(CornerRadiusManager.currentSidebarRadius() ?? 19)
        floatingSidebar = CornerRadiusManager.currentFloatingSidebar() ?? true
    }
}
