
import SwiftUI

extension Text {
    func tokenFont(_ token: FontToken, color: Color? = nil) -> Text {
        self.font(token.font()).foregroundColor(color == nil ? token.color() : color)
    }
}

extension View {
    func tokenFont(_ token: FontToken, color: Color? = nil) -> some View {
        self.font(token.font()).foregroundColor(color == nil ? token.color() : color)
    }
}
