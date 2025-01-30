import SwiftUI

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?

    func start() {
        let view = CustomTabView()
            .navigationBarTitleDisplayMode(.inline)

        currentView = AnyView(
            NavigationView {
                view
            }
        )
    }
    /*
    func goToConfirmCode() {
        let view = ConfirmCodeScreen()
            .navigationBarTitleDisplayMode(.inline)

        currentView = AnyView(
            NavigationView {
                view
            }
        )
    }*/
}
