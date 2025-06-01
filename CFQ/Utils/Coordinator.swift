
import FirebaseAuth
import SwiftUI
import Firebase

class Coordinator: ObservableObject {
    @Published var currentView: AnyView?
    @Published var selectedTab = 0
    @Published var user: User?
    @Published var showFriendList = false
    @Published var showProfileFriend = false
    @Published var showTeamDetail = false
    @Published var showCreateTeam = false
    @Published var showTurnCardView = false
    @Published var showNotificationScreen = false
    @Published var showFriendListScreen = false
    @Published var showCFQForm = false
    @Published var showMessageScreen = false
    @Published var showTeamDetailEdit = false
    @Published var showMapFullScreen = false
    @Published var showTurnFeedDetail = false
    @Published var showSheetParticipateAnswers = false
    @Published var showMessagerieScreen = false
    
    @Published var dataApp = DataApp()
    @Published var teamDetail: TeamGlobal?
    @Published var turnSelected: Turn?
    @Published var turnSelectedPreview: TurnPreview?
    
    @Published var userCFQ: [CFQ] = []
    @Published var userFriends: [UserContact] = []
    @Published var profileUserSelected: User = User()
    @Published var selectedConversation: Conversation?
    @Published var selectedCFQ: CFQ?

    private var auth = Auth.auth()
    private var firebaseService = FirebaseService()
    private var listeners = [ListenerRegistration?]()
    
    func start(userUID: String?) {
        if let userUID = userUID {
            
            let listener = firebaseService.getDataByID(from: .users, with: userUID, listenerKeyPrefix: ListenerType.user.rawValue) { (result: Result<User, Error>) in
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user.uid, forKey: "userUID")

                    self.user = user

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
                case .failure(let error):
                    print("@@@ error \(error)")
                    self.currentView = AnyView(
                        NavigationView {
                            SignScreen(coordinator: self)
                        }
                    )
                    Logger.log("User connected but not account ", level: .info)
                }
            }
            listeners.append(listener)
            /*
            firebaseService.getDataByIDs(
                from: .users,
                with: [userUID],
                listenerKeyPrefix: ListenerType.user.rawValue
            ) { (result: Result<[User], Error>) in
                switch result {
                case .success(let user):
                    UserDefaults.standard.set(user[0].uid, forKey: "userUID")

                    self.user = user[0]

                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"), user[0].tokenFCM != fcmToken {
                        self.firebaseService.updateDataByID(data: ["tokenFCM": fcmToken], to: .users, at: user[0].uid)
                    }

                    self.catchDataAppToStart()
                    self.catchAllUsersFriend(user: user[0])
                    self.catchAllUserCFQ(user: user[0])
                    
                    self.currentView = AnyView(
                        NavigationView {
                            CustomTabView(coordinator: self)
                                .environmentObject(user[0])
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
            */
        } else {
            
            currentView = AnyView(
                NavigationView {
                    SignScreen(coordinator: self)
                }
            )
            Logger.log("User not connected and not account ", level: .info)
            /// when user hasn't an id and no account
        }
    }

    func removeAllInformationToCoordinator() {
        selectedTab = 0
        user = User()
        showFriendList = false
        showProfileFriend = false
        showTeamDetail = false
        showCreateTeam = false
        showTurnCardView = false
        showNotificationScreen = false
        showFriendListScreen = false
        showCFQForm = false
        showMessageScreen = false
        showTeamDetailEdit = false
        dataApp = DataApp()
        turnSelected = nil
        firebaseService.removeAllListeners()
    }

    func logOutUser() {
        do {
            try self.auth.signOut()
            self.removeAllInformationToCoordinator()
            self.currentView = AnyView(
                NavigationView {
                    SignScreen(coordinator: self)
                }
            )
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
        user.invitedCfqs = removeEmptyIdInArray(data: user.invitedCfqs ?? [""])

        if let invitedCfqs = user.invitedCfqs, !invitedCfqs.isEmpty {
            firebaseService.getDataByIDs(
                from: .cfqs,
                with: invitedCfqs,
                listenerKeyPrefix: ListenerType.cfq.rawValue
            ){ (result: Result<[CFQ], Error>) in
                switch result {
                case .success(let cfq):
                    DispatchQueue.main.async {
                        self.userCFQ = cfq
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func catchAllUsersFriend(user: User) {
        user.friends = removeEmptyIdInArray(data: user.friends)
        
        if !user.friends.isEmpty {
             
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
    }

    func gotoCustomTabView(user: User) {
        currentView = AnyView(
            NavigationView {
                CustomTabView(coordinator: self)
                    .environmentObject(user)
            }
        )
    }
    
    private func removeEmptyIdInArray(data: [String]) -> [String] {
        var data = data
        data.indices.forEach({ index in
            if data[index] == "" {
                data.remove(at: index)
            }
        })

        return data
    }
}
