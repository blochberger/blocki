import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

struct BlockiApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    @MainActor
    func applyWindowStyle() {
        NSWindow.allowsAutomaticWindowTabbing = false
        for window in NSApplication.shared.windows {
            window.titlebarAppearsTransparent = true
            window.collectionBehavior = [.primary, .fullScreenNone]
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView().task { applyWindowStyle() }
        }
        .windowResizability(.contentMinSize)
        .commands {
            // Disable some superfluous menu entries
            CommandGroup(replacing: .systemServices) {}
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            // Help
            CommandGroup(replacing: .help) { HelpMenu() }
        }
    }
}
