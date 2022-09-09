import Cocoa
import SafariServices

import BlockiKit

class ViewController: NSViewController {

	@IBOutlet weak var stateLabel: NSTextField!
	@IBOutlet weak var detailsLabel: NSTextField!

	@IBAction func refreshStateAction(_ sender: NSButton) {
		refreshState()
	}

	@IBAction func reloadExtensionAction(_ sender: NSButton) {
		reloadExtension()
	}

	func signal(message: String, details: String? = nil, isError: Bool = false) {
		let textColor = isError ? NSColor.red : nil

		stateLabel.textColor = textColor
		stateLabel.stringValue = message
		detailsLabel.textColor = textColor
		detailsLabel.stringValue = details ?? ""
	}

	func signal(error: Error) {
		signal(message: error.localizedDescription, details: (error as NSError).helpAnchor, isError: true)
	}

	func reloadExtension() {
		SFContentBlockerManager.reloadContentBlocker(withIdentifier: Blocki.extensionIdentifier) {
			optionalError in

			if let error = optionalError {
				DispatchQueue.main.async {
					self.signal(error: error)
				}
			} else {
				self.refreshState()
			}
		}
	}

	func refreshState() {
		SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Blocki.extensionIdentifier) {
			(optionalState, optionalError) in

			if let error = optionalError {
				DispatchQueue.main.async {
					self.signal(error: error)
				}
				return
			}

			let state = optionalState!

			let message = state.isEnabled
				? NSLocalizedString("The Extension is enabled.", comment: "Text indicating that the extension is enabled in Safari.")
				: NSLocalizedString("The Extension is not enabled.", comment: "Text indicating that the extension is not enabled in Safari.")

			DispatchQueue.main.async {
				self.signal(message: message)
			}
		}
	}

	@IBAction func editBlocklist(_ sender: NSButton) {
		NSWorkspace.shared.open(Blocki.blockerListUrl)
	}

	// MARK: NSViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		// If there is no blocker list yet, create an empty one.
		let manager = FileManager.default

		if !manager.fileExists(atPath: Blocki.blockerListUrl.path) {
			let blockerList = Data("[]".utf8)
			let created = manager.createFile(atPath: Blocki.blockerListUrl.path, contents: blockerList)
			if !created {
				let localizedMessage = NSLocalizedString("Could not create blocker list.", comment: "Error that occurs, when the blocker list file could not be created inside the application group's container.")
				signal(message: localizedMessage, isError: true)
				return
			}
		}

		// Check whether the extension is enabled automatically.
		refreshState()
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}

}
