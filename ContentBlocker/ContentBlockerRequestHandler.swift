import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        guard let attachment = NSItemProvider(contentsOf: Blocki.blockListUrl) else {
            context.cancelRequest(withError: Blocki.Error.blockListNotAvailable)
            return
        }

        let item = NSExtensionItem()
        item.attachments = [attachment]

        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
