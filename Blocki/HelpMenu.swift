import SwiftUI

struct HelpMenu: View {
    var body: some View {
        Group {
            Link(
                "Content blocker documentation…",
                destination: URL(
                    string: "https://developer.apple.com/documentation/safariservices/creating_a_content_blocker"
                )!
            )
            Link("View source code on GitHub…", destination: URL(string: "https://github.com/blochberger/blocki")!)
        }
    }
}

#Preview {
    HelpMenu()
}
