import SwiftUI

@main
struct BlockiApp: App {
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
        }.commands {
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
