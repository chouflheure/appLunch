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

// Background 
public extension View {
     func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.keyboard)
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, -100)
        )
    }
}

extension View {
    func customNavigationBackButton<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        self.modifier(
            NavigationBarModifier(customBackButton: AnyView(content()), customMoreButton: nil))
    }
    
    func customNavigationButtons<LeftContent: View, RightContent: View>(
        @ViewBuilder leftButton: () -> LeftContent,
        @ViewBuilder rightButton: () -> RightContent
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                customBackButton: AnyView(leftButton()),
                customMoreButton: AnyView(rightButton())
            )
        )
    }
    
    func customNavigationFlexible<LeftContent: View, CenterContent: View, RightContent: View>(
        leftElement: (() -> LeftContent)? = nil,
        centerElement: (() -> CenterContent)? = nil,
        rightElement: (() -> RightContent)? = nil,
        hasADivider: Bool
        ) -> some View {
            self.modifier(
                NavigationBarThreeElementsModifier(
                    leftElement: leftElement != nil ? AnyView(leftElement!()) : AnyView(EmptyView()),
                    centerElement: centerElement != nil ? AnyView(centerElement!()) : nil,
                    rightElement: rightElement != nil ? AnyView(rightElement!()) : nil,
                    hasADivider: hasADivider
                )
            )
        }
}

extension View {
    func tokenFont(_ token: FontToken, color: Color? = nil) -> some View {
        self.font(token.font()).foregroundColor(color == nil ? token.color() : color)
    }
}
