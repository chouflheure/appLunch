import FirebaseAuth
import SwiftUI

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?
    private var firebaseService = FirebaseService()
    @Published var user = User()
    @Published var showFriendList = false
    @Published var showProfileFriend = false
    @Published var showTeamDetail = false
    @Published var showCreateTeam = false
    @Published var showTurnCardView = false
    @Published var showNotificationScreen = false
    @Published var selectedTab = 0
    @Published var showFriendListScreen = false
    @Published var showCFQForm = false
    @Published var showMessageScreen = false
    @Published var showTeamDetailEdit = false

    @Published var dataApp = DataApp()
    @Published var teamDetail: TeamGlobal?
    @Published var turnSelected: Turn?
    
    @Published var userFriends: [UserContact] = []
    @Published var userCFQ: [CFQ] = []

    func start() {
        /// when user has an id and an account
        if let user = Auth.auth().currentUser {
            firebaseService.getDataByID(from: .users, with: user.uid) { (result: Result<User, Error>) in
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user.uid, forKey: "userUID")

                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"), user.tokenFCM != fcmToken {
                        self.firebaseService.updateDataByID(data: ["tokenFCM": fcmToken], to: .users, at: user.uid)
                    }
                    
                    self.catchDataAppToStart()
                    self.catchAllUsersFriend(user: user)
                    self.catchAllUserCFQ(user: user)
                    
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

    func catchDataAppToStart() {
        firebaseService.getDataByID(
            from: .dataApp,
            with: CollectionFirebaseType.dataApp.rawValue
        ) { (result: Result<DataApp, Error>) in
            switch result {
            case .success(let data):
                self.dataApp = data

            case .failure( let e):
                print("@@@ e = \(e)")
                
            }
            
        }
    }
    
    func catchAllUserCFQ(user: User) {
        firebaseService.getDataByIDs(
            from: .cfqs,
            with: user.invitedCfqs ?? [""],
            listenerKeyPrefix: ListenerType.cfq.rawValue
        ){ (result: Result<[CFQ], Error>) in
            switch result {
                case .success(let cfq):
                    print("@@@ user CFQ : \(cfq)")
                    DispatchQueue.main.async {
                        self.userCFQ = cfq
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")

                }
            }
    }
    
    func catchAllUsersFriend(user: User) {
        firebaseService.getDataByIDs(
            from: .users,
            with: user.friends,
            listenerKeyPrefix: ListenerType.friends.rawValue
        ){ (result: Result<[UserContact], Error>) in
            switch result {
                case .success(let userContact):
                    DispatchQueue.main.async {
                        self.userFriends = userContact
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")

                }
            }
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
