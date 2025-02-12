
import SwiftUI

extension Text {
    func tokenFont(_ token: FontToken) -> Text {
        self.font(token.font()).foregroundColor(token.color())
    }
}
