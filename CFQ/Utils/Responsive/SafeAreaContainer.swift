
import SwiftUI

struct SafeAreaContainer<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack() {
            NeonBackgroundImage()
                    
            VStack(spacing: 0) {
                content
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
