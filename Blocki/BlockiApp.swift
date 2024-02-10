import SwiftUI

@main
struct BlockiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DispatchQueue.main.async {
                        NSApplication.shared.windows.forEach {
                            window in
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
