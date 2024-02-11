import Foundation

public struct Blocki {
    public enum Error: Swift.Error {
        case blockListNotAvailable
        case noApplicationGroup
    }

    let applicationGroup: String

    // TODO: Find value programmatically.
    public let extensionIdentifier = "io.github.blochberger.Blocki.ContentBlocker"

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
