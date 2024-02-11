import SafariServices
import SwiftUI

import BlockiKit

struct ContentView: View {
    @State private var isRefreshingState: Bool = false
    @State private var isReloadingRules: Bool = false
    @State private var extensionIsEnabled: Bool = false
    @State private var error: Error? = nil

    func reloadRules() {
        error = nil
        isReloadingRules = true
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: Blocki.extensionIdentifier) {
            optionalError in

            if let error = optionalError {
                DispatchQueue.main.async {
                    self.error = error
                    self.isReloadingRules = false
                }
                return
            }
            self.isReloadingRules = false
            self.refreshState()
        }
    }

    func refreshState() {
        error = nil
        isRefreshingState = true
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Blocki.extensionIdentifier) {
            (optionalState, optionalError) in

            if let error = optionalError {
                DispatchQueue.main.async {
                    self.error = error
                    self.isRefreshingState = false
                }
                return
            }

            let state = optionalState!
            DispatchQueue.main.async {
                self.extensionIsEnabled = state.isEnabled
                self.isRefreshingState = false
            }
        }
    }

    func editBlocklist() {
        NSWorkspace.shared.open(Blocki.blockListUrl)
    }


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: extensionIsEnabled ? "bolt.fill" : "bolt.slash.fill").foregroundStyle(.accent)
                Text(extensionIsEnabled ? "The extension is enabled." : "The extension is not enabled.")
            }
            if let error = self.error {
                Text(error.localizedDescription).bold().foregroundStyle(.red)
                if let helpAnchor = (error as NSError).helpAnchor {
                    Text(helpAnchor).foregroundStyle(.red) // not localized
                }
            }
            Spacer()
            Button(action: refreshState) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh state").frame(maxWidth: .infinity)
            }.disabled(isRefreshingState)
            Button(action: editBlocklist) {
                Image(systemName: "pencil")
                Text("Edit rules…").frame(maxWidth: .infinity)
            }
            Button(action: reloadRules) {
                Image(systemName: "safari")
                Text("Reload rules in Safari").frame(maxWidth: .infinity)
            }.disabled(!extensionIsEnabled || isReloadingRules)
        }
        .padding()
        .onAppear {
            // If there is no blocker list yet, create an empty one.
            do {
                try Blocki.initializeBlockList()
            } catch {
                self.error = error
            }
            refreshState()
        }
    }
}

#Preview {
    ContentView()
}
