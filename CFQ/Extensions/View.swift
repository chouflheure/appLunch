import SwiftUI

public extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func glow(color: Color = .gray, radius: CGFloat = 20) -> some View {
      self
        .shadow(color: color, radius: radius / 3)
        .shadow(color: color, radius: radius / 3)
        .shadow(color: color, radius: radius / 3)
    }
    
    internal func toastView(toast: Binding<Toast?>) -> some View {
      self.modifier(ToastModifier(toast: toast))
    }
}
