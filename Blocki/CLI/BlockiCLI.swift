import ArgumentParser
import BlockiKit

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        self.write(Data(string.utf8))
    }
}

struct UI: AsyncParsableCommand {
    @Argument(
        parsing: .captureForPassthrough,
        help: "Pass through arguments to the Blocki app, such as -NSShowNonLocalizedStrings or -ApplePersistenceIgnoreState."
    ) var arguments: [String] = []

    static let configuration = CommandConfiguration(abstract: "Run the Blocki app.")
}

struct Status: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Check the status of the extension.",
        discussion: "The command returns with exit code 0 if the extension is active and 1 otherwise.")

    func run() async throws {
        let isEnabled = try await Blocki.isEnabled()
        print(isEnabled ? "The extension is enabled." : "The extension is not enabled.")
        throw isEnabled ? ExitCode.success : ExitCode.failure
    }
}

struct Reload: AsyncParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Reload the rules in Safari.")

    func run() async throws {
        try await Blocki.reloadBlocklist()
    }
}

struct BlockiCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "blocki",
        abstract: "A Safari Content Blocker extension where you are in control.",
        version: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String,
        subcommands: [UI.self, Status.self, Reload.self],
        defaultSubcommand: UI.self)
}
