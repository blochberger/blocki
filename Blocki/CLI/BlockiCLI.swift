import ArgumentParser
import BlockiKit

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        self.write(Data(string.utf8))
    }
}

struct UI: AsyncParsableCommand {
    // Ignore system arguments for UI applications, such as
    // `-NSShowNonLocalizedStrings`, `-ApplePersistenceIgnoreState`, etc.
    @Argument(parsing: .captureForPassthrough) var arguments: [String] = []
}

struct Status: AsyncParsableCommand {
    func run() async throws {
        let isEnabled = try await Blocki.isEnabled()
        print(isEnabled ? "The extension is enabled." : "The extension is not enabled.")
        throw isEnabled ? ExitCode.success : ExitCode.failure
    }
}

struct Reload: AsyncParsableCommand {
    func run() async throws {
        try await Blocki.reloadBlocklist()
    }
}

struct BlockiCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "blocki",
        version: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,
        subcommands: [UI.self, Status.self, Reload.self],
        defaultSubcommand: UI.self)
}
