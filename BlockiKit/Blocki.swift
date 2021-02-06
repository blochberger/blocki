import Foundation

public class Blocki {

	/// - TODO: Find value programmatically.
	public static let extensionIdentifier = "io.github.blochberger.Blocki.Extension"

	/// - TODO: Find value programmatically.
	public static let applicationGroupIdentifier = "Q7Y592HJR8.Blocki"

	public static var container: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: applicationGroupIdentifier)!

	public static var blockerListUrl = container.appendingPathComponent("blockerList.json", isDirectory: false)

}
