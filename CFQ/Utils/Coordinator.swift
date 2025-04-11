import FirebaseAuth
import SwiftUI

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?
    private var firebase = FirebaseService()
    @Published var user = User()
    @Published var showFriendList = false
    @Published var showProfileFriend = false
    @Published var showTeamDetail = false
    @Published var showCreateTeam = false
    @Published var showTurnCardView = false
    @Published var showNotificationScreen = false
    @Published var selectedTab = 0
    @Published var showFriendListScreen = false
    @Published var showCFQScreen = false

    func start() {
        /// when user has an id and an account
        if let user = Auth.auth().currentUser {
            firebase.getDataByID(from: .users, with: user.uid) { (result: Result<User, Error>) in
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user.uid, forKey: "userUID")

                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"), user.tokenFCM != fcmToken {
                        self.firebase.updateDataByID(data: ["tokenFCM": fcmToken], to: .users, at: user.uid)
                    }
                    self.currentView = AnyView(
                        NavigationView {
                            CustomTabView(coordinator: self)
                                .environmentObject(user)
                        }
                    )
                    Logger.log("User connected and have account ", level: .info)
                
                /// when user has an id but not account
                case .failure(_):
                    self.currentView = AnyView(
                        NavigationView {
                            SignScreen(coordinator: self)
                        }
                    )
                    Logger.log("User connected but not account ", level: .info)
                }
            }
        /// when user hasn't an id and no account
        } else {
            currentView = AnyView(
                NavigationView {
                    SignScreen(coordinator: self)
                }
            )
            Logger.log("User not connected and not account ", level: .info)
        }

/*
        // ##### TEST ####

        let view = CustomTabView(coordinator: .init())
        currentView = AnyView(
            NavigationView {
                view
            }
        )
        // #### TEST ####
 */
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

    func gotoCustomTabView(user: User) {
        currentView = AnyView(
            NavigationView {
                CustomTabView(coordinator: self)
                    .environmentObject(user)
            }
        )
    }
}
