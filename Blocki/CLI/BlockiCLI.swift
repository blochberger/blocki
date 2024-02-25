import ArgumentParser
import BlockiKit

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        self.write(Data(string.utf8))
    }
}

struct UI: AsyncParsableCommand {
}

struct Status: AsyncParsableCommand {
    func run() async throws {
        let isEnabled = try await Blocki.isEnabled()
        print(isEnabled ? "Extension is enabled." : "Extension is not enabled.")
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
        subcommands: [UI.self, Status.self, Reload.self],
        defaultSubcommand: UI.self)
}
