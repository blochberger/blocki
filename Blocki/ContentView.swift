import BlockiKit
import SafariServices
import SwiftUI

struct ContentView: View {
    @State private var blocki: Blocki? = nil
    @State private var isRefreshingState: Bool = false
    @State private var isReloadingRules: Bool = false
    @State private var extensionIsEnabled: Bool = false
    @State private var error: Error? = nil

    var isLoading: Bool { blocki == nil }
    var canReloadRules: Bool { !isLoading && extensionIsEnabled && !isReloadingRules }
    var canRefreshState: Bool { !isLoading && !isRefreshingState }

    func reloadRules() {
        precondition(canReloadRules)

        error = nil
        isReloadingRules = true
        SFContentBlockerManager.reloadContentBlocker(withIdentifier: blocki!.extensionIdentifier) {
            optionalError in

            DispatchQueue.main.async {
                guard let error = optionalError else {
                    self.isReloadingRules = false
                    self.refreshState()
                    return
                }
                self.error = error
                self.isReloadingRules = false
            }
        }
    }

    func refreshState() {
        precondition(canRefreshState)

        error = nil
        isRefreshingState = true
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: blocki!.extensionIdentifier) {
            (optionalState, optionalError) in

            DispatchQueue.main.async {
                guard let state = optionalState else {
                    precondition(optionalError != nil)
                    self.error = optionalError
                    self.isRefreshingState = false
                    return
                }
                self.extensionIsEnabled = state.isEnabled
                self.isRefreshingState = false
            }
        }
    }

    func editBlocklist() {
        precondition(!isLoading)
        NSWorkspace.shared.open(blocki!.blockListUrl)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(
                    systemName: isLoading
                        ? "hourglass"
                        : (extensionIsEnabled
                            ? "bolt.fill"
                            : "bolt.slash.fill")
                ).foregroundStyle(.accent)
                Text(
                    isLoading
                        ? "Loading…"
                        : (extensionIsEnabled
                            ? "The extension is enabled."
                            : "The extension is not enabled.")
                )
            }
            if let error = self.error {
                Text(error.localizedDescription).bold().foregroundStyle(.red)
                if let helpAnchor = (error as NSError).helpAnchor {
                    Text(helpAnchor).foregroundStyle(.red)  // not localized
                }
            }
            Spacer()
            Button(action: refreshState) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh state").frame(maxWidth: .infinity)
            }.disabled(!canRefreshState)
            Button(action: editBlocklist) {
                Image(systemName: "pencil")
                Text("Edit rules…").frame(maxWidth: .infinity)
            }.disabled(isLoading)
            Button(action: reloadRules) {
                Image(systemName: "safari")
                Text("Reload rules in Safari").frame(maxWidth: .infinity)
            }.disabled(!canReloadRules)
        }
        .padding()
        .task {
            // If there is no blocker list yet, create an empty one.
            DispatchQueue.global().async {
                let blocki: Blocki
                do {
                    blocki = try Blocki()
                } catch {
                    DispatchQueue.main.async {
                        self.error = error
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.blocki = blocki
                    do {
                        try blocki.initializeBlockList()
                    } catch {
                        self.error = error
                    }
                    self.refreshState()
                }
            }
        }
        .frame(minWidth: 300, minHeight: 150)
    }
}

#Preview {
    ContentView()
}
