
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    let customBackButton: AnyView

    func body(content: Content) -> some View {
        content
            .background(
                NavigationControllerAccessor { navigationController in
                    navigationController?.interactivePopGestureRecognizer?
                        .isEnabled = true
                    navigationController?.interactivePopGestureRecognizer?
                        .delegate = nil
                }
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    customBackButton
                }
            }
    }
}
