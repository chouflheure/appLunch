
import SwiftUI
import FirebaseAuth

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?

    func start() {
/*
        if let user = Auth.auth().currentUser {
            print("Utilisateur connecté :", user.uid)
        } else {
            print("Aucun utilisateur connecté.")
        }*/

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
