
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
    let hasADivider: Bool

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if hasADivider {
                Divider()
                    .frame(height: 0.5)
                    .background(.white)
            }

            content
                .padding(.top, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 10)
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
