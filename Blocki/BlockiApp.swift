import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

@main
struct BlockiApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                    DispatchQueue.main.async {
                        for window in NSApplication.shared.windows {
                            window.titlebarAppearsTransparent = true
                            window.collectionBehavior = [.fullScreenNone]
                        }
                    }
                }
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
