import ArgumentParser
import Foundation

// Required for actually executing the `run() async` overload instead of the
// synchronous one, see
// https://github.com/apple/swift-argument-parser/issues/538#issuecomment-1950992918
extension AsyncParsableCommand {
    mutating func runAsync() async throws {
        try await self.run()
    }
}

let arguments: [String] = Array(CommandLine.arguments.dropFirst())

var command: ParsableCommand
do {
    command = try BlockiCLI.parseAsRoot(arguments)
} catch {
    BlockiCLI.exit(withError: error)
}

// Run UI command
// Starting the UI in `UI.run()` would block threads.
guard type(of: command) != UI.self else {
    BlockiApp.main()
    exit(EXIT_SUCCESS)
}

// Run CLI command
do {
    if var asyncCommand = command as? AsyncParsableCommand {
        try await asyncCommand.runAsync()
    } else {
        try command.run()
    }
} catch {
    BlockiCLI.exit(withError: error)
}
