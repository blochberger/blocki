import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBAction func openContentBlockerDocumentation(_ sender: NSMenuItem) {
		NSWorkspace.shared.open(URL(string: "https://developer.apple.com/documentation/safariservices/creating_a_content_blocker")!)
	}

	@IBAction func viewOnGithub(_ sender: NSMenuItem) {
		NSWorkspace.shared.open(URL(string: "https://github.com/blochberger/blocki")!)
	}
	
	// MARK: NSApplicationDelegate

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
