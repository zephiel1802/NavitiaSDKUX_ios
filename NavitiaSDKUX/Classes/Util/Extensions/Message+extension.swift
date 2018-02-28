import Foundation

extension Message {
    public var escapedText: String? {
        if (self.text == nil) {
            return nil
        }

        do {
            return try NSAttributedString(
                data: Data(self.text!.utf8),
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            ).string
        } catch {
            return nil
        }
    }
}
