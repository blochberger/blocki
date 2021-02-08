import Foundation

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        guard let attachment = NSItemProvider(contentsOf: Blocki.blockerListUrl) else {
            context.cancelRequest(withError: BlockiError.blockListNotAvailable)
            return
        }

        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
    
}
