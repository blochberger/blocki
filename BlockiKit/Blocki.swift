import Foundation
import SafariServices

public struct Blocki {
    public enum Error: Swift.Error {
        case blockListNotAvailable
        case noApplicationGroup
    }

    let applicationGroup: String

    public static var extensionIdentifier: String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Could not find bundle identifier. The app may have been launched through a symbolic link, which is currently not supported, see #10.")
        }
        return bundleIdentifier + ".ContentBlocker"
    }

    public static func isEnabled() async throws -> Bool {
        let state = try await SFContentBlockerManager.stateOfContentBlocker(withIdentifier: extensionIdentifier)
        return state.isEnabled
    }

    public static func reloadBlocklist() async throws {
        try await SFContentBlockerManager.reloadContentBlocker(withIdentifier: extensionIdentifier)
    }

    init(codeSignature: CodeSignature) throws {
        for applicationGroup in codeSignature.applicationGroups {
            if applicationGroup.hasSuffix(".Blocki") {
                self.applicationGroup = applicationGroup
                return
            }
        }
        throw Error.noApplicationGroup
    }

    public init() throws {
        try self.init(codeSignature: CodeSignature())
    }

    var groupContainer: URL {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroup)!
    }

    public var blockListUrl: URL {
        groupContainer.appending(component: "blockerList.json")
    }

    public func initializeBlockList() throws {
        if !FileManager.default.fileExists(atPath: blockListUrl.path) {
            try Data("[]".utf8).write(to: blockListUrl)
        }
    }
}
