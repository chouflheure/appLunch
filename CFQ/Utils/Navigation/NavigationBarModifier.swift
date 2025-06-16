
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    let customBackButton: AnyView
    let customMoreButton: AnyView?

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

                ToolbarItem(placement: .topBarTrailing) {
                    customMoreButton
                }

            }
    }
}

struct NavigationBarThreeElementsModifier: ViewModifier {
    let leftElement: AnyView
    let centerElement: AnyView?
    let rightElement: AnyView?

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
                ToolbarItem(placement: .navigationBarLeading) {
                    leftElement
                }
            
                if let centerElement = centerElement {
                    ToolbarItem(placement: .principal) {
                        centerElement
                    }
                }
                
                if let rightElement = rightElement {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        rightElement
                    }
                }
            }
        }
}
