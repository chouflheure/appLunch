
import SwiftUI
import FirebaseAuth

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?

    func start() {
/*
        if let user = Auth.auth().currentUser {
            currentView = AnyView(
                NavigationView {
                    CustomTabView()
                }
            )
            print("Utilisateur connecté :", user.uid)
        } else {
            currentView = AnyView(
                NavigationView {
                    // SignScreen()
                    CustomTabView()
                }
            )
            print("Aucun utilisateur connecté.")
        }
*/
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
