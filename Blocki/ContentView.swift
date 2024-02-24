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

    @Sendable
    func reloadRules() async {
        precondition(canReloadRules)

        defer { isReloadingRules = false }

        error = nil
        isReloadingRules = true
        do {
            try await SFContentBlockerManager.reloadContentBlocker(withIdentifier: Blocki.extensionIdentifier)
        } catch {
            self.error = error
            return
        }
        await refreshState()
    }

    @Sendable
    func refreshState() async {
        precondition(canRefreshState)

        defer { isRefreshingState = false }

        error = nil
        isRefreshingState = true
        let state: SFContentBlockerState
        do {
            state = try await SFContentBlockerManager.stateOfContentBlocker(withIdentifier: Blocki.extensionIdentifier)
        } catch {
            self.error = error
            return
        }
        extensionIsEnabled = state.isEnabled
    }

    func editBlocklist() {
        precondition(!isLoading)
        NSWorkspace.shared.open(blocki!.blockListUrl)
    }

    @Sendable
    func initializeBlocki() async {
        do {
            blocki = try Blocki()
            // If there is no blocker list yet, create an empty one.
            try blocki!.initializeBlockList()
            await refreshState()
        } catch {
            self.error = error
            return
        }
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
            Button(action: { Task(operation: refreshState) }) {
                Image(systemName: "arrow.clockwise")
                Text("Refresh state").frame(maxWidth: .infinity)
            }.disabled(!canRefreshState)
            Button(action: editBlocklist) {
                Image(systemName: "pencil")
                Text("Edit rules…").frame(maxWidth: .infinity)
            }.disabled(isLoading)
            Button(action: { Task(operation: reloadRules) }) {
                Image(systemName: "safari")
                Text("Reload rules in Safari").frame(maxWidth: .infinity)
            }.disabled(!canReloadRules)
        }
        .padding()
        .task(initializeBlocki)
        .frame(minWidth: 300, minHeight: 150)
    }
}

#Preview {
    ContentView()
}
