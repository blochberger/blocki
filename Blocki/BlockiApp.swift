import SwiftUI

@main
struct BlockiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DispatchQueue.main.async {
                        for window in NSApplication.shared.windows {
                            window.titlebarAppearsTransparent = true
                            window.collectionBehavior = [.fullScreenNone]
                        }
                    }
                }
        }.commands {
            CommandGroup(replacing: .help) { HelpMenu() }
        }
    }
}
