
import SwiftUI

extension Text {
    func tokenFont(_ token: FontToken) -> Text {
        var text = self.font(token.font()).foregroundColor(token.color())
        if token.isBold() {
            text = text.bold()
        }
        return text
    }
}
