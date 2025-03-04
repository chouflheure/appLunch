import FirebaseAuth
import SwiftUI

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?
    private var firebase = FirebaseService()
    @Published var user = User()

    func start() {
        /*
        if let user = Auth.auth().currentUser {
            firebase.getDataByID(from: .users, with: user.uid) { (result: Result<User, Error>) in
                switch result {
                case .success(let user):
                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"), user.tokenFCM != fcmToken {
                        print("Le token FCM est : \(fcmToken)")
                        user.tokenFCM = fcmToken
                        self.firebase.updateDataByID(data: [    "tokenFCM": fcmToken], to: .users, at: user.uid)
                    }
                    self.currentView = AnyView(
                        NavigationView {
                            CustomTabView(coordinator: self)
                                .environmentObject(user)
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
        
        let view = ProfileView(coordinator: self)
        currentView = AnyView(
            NavigationView {
                view
            }
        )

    }

    func logOutUser() {
        do {
            try Auth.auth().signOut()
            print("User successfully signed out.")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        currentView = AnyView(
            NavigationView {
                SignScreen(coordinator: self)
            }
        )
    }

    func gotoCustomTabView() {
        currentView = AnyView(
            NavigationView {
                CustomTabView(coordinator: self)
            }
        )
    }
}
