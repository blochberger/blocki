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
				? NSLocalizedString("The extension is enabled.", comment: "Text indicating that the extension is enabled in Safari.")
				: NSLocalizedString("The extension is not enabled.", comment: "Text indicating that the extension is not enabled in Safari.")

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
		do {
			try Blocki.initializeBlockList()
		} catch {
			self.signal(error: error)
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
