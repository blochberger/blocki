import Foundation

public class Blocki {
    public enum Error: Swift.Error {
        case blockListNotAvailable
    }

    // TODO: Find value programmatically.
    public static let extensionIdentifier = "io.github.blochberger.Blocki.ContentBlocker"

    // TODO: Find value programmatically.
    public static let teamIdentifier = "Q7Y592HJR8"

    // TODO: Find value programmatically.
    public static let applicationGroupIdentifier = "\(teamIdentifier).Blocki"

    public static var container: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier)!

    public static var blockListUrl = container.appendingPathComponent("blockerList.json", isDirectory: false)

    public static func initializeBlockList() throws {
        if !FileManager.default.fileExists(atPath: blockListUrl.path) {
            try Data("[]".utf8).write(to: blockListUrl)
        }
    }
}
