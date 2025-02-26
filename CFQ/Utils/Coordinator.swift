
import SwiftUI
import FirebaseAuth

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?
    private var firebase = FirebaseService()
    
    func start() {
        /*
        if let user = Auth.auth().currentUser {
            firebase.getDataByID(from: .users, with: user.uid) { (result: Result<User, Error>) in
                switch result {
                case .success(let user):
                    self.currentView = AnyView(
                        NavigationView {
                            CustomTabView()
                        }
                    )
                case .failure(let error):
                    self.currentView = AnyView(
                        NavigationView {
                            SignScreen(coordinator: self)
                        }
                    )
                    Logger.log("No user connected", level: .info)
                }
            }
        } else {
            currentView = AnyView(
                NavigationView {
                    SignScreen(coordinator: self)
                }
            )
            print("Aucun utilisateur connecté.")
        }
    */

        // ##### TEST ##### 
        let view = SignUpPageView(viewModel: .init(uidUser: "JtISdWec8JV4Od1WszEGXkqEVAI2"), coordinator: self)

        currentView = AnyView(
            NavigationView {
                view
            }
        )
    
    }
 
    func gotoCustomTabView() {
        currentView = AnyView(
            NavigationView {
                CustomTabView()
            }
        )
    }
}
