import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let blocki: Blocki
        do {
            blocki = try Blocki()
        } catch {
            context.cancelRequest(withError: error)
            return
        }

        guard let attachment = NSItemProvider(contentsOf: blocki.blockListUrl) else {
            context.cancelRequest(withError: Blocki.Error.blockListNotAvailable)
            return
        }

        let item = NSExtensionItem()
        item.attachments = [attachment]

        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
}
