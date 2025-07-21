
import Foundation
import SwiftUI
import Firebase

class AddFriendsViewModel: ObservableObject {
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var showFriendsList: Bool = false
    @ObservedObject var coordinator: Coordinator

    var firebaseService = FirebaseService()
    @Published var user: User
    private var allFriends = Set<UserContact>()

    @Published var friendsList = Set<UserContact>()
    @Published var requestsFriends = Set<UserContact>()

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.pseudo.lowercased().hasPrefix(word) || name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        guard let user = coordinator.user else {
            self.user = User()
            return
        }
        self.user = user

        fecthAllUsers()
        fetchRequestsFriends(requestsFriendsIds: self.user.requestsFriends)
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        friendsList = allFriends
        friendsList = filteredNames
    }
    
    func statusFriend(user: User, userFriend: UserContact) -> CellFriendPseudoNameActionType {
        if user.friends.contains(userFriend.uid) {
            return .remove
        }
        if user.sentFriendRequests.contains(userFriend.uid) {
            return .cancel
        }
        if user.requestsFriends.contains(userFriend.uid) {
            return .accept
        } else {
            return .add
        }
    }
}

extension AddFriendsViewModel {
    
    func fetchRequestsFriends(requestsFriendsIds: [String]) {
        firebaseService.getDataByIDs(
            from: .users,
            with: requestsFriendsIds,
            onUpdate: {(result: Result<[UserContact], Error>) in
                switch result {
                case .success(let users):
                    self.requestsFriends = Set(users)
                case .failure(let error):
                    print("- Erreur :", error.localizedDescription)
                }
            }
        )
    }

    func fecthAllUsers() {
        firebaseService.getAllData(from: .users) { (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                
                self.friendsList = Set(users)
                self.allFriends = Set(users)
                
                if let userToRemove = users.first(where: { $0.uid == self.user.uid }) {
                    self.friendsList.remove(userToRemove)
                    self.allFriends.remove(userToRemove)
                }
                
                // completion(users)
            case .failure(let error):
                print("- Erreur :", error.localizedDescription)
            }
        }
    }
    
    func actionOnClickButtonAddFriend(type: CellFriendPseudoNameActionType, userFriend: UserContact) {
        if type == .add {
            addFriendsToList(userFriend: userFriend)
        }
        if type == .accept {
            acceptFriendsToList(userFriend: userFriend)
        }
        if type == .cancel {
            cancelFriendsToList(userFriend: userFriend)
        }
        if type == .remove {
            removeFriendsToList(userFriend: userFriend)
        }
    }

    private func addFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: ["sentFriendRequests": FieldValue.arrayUnion([userFriend.uid])],
            to: .users,
            at: self.user.uid
        )
        
        firebaseService.updateDataByID(
            data: ["requestsFriends": FieldValue.arrayUnion([user.uid])],
            to: .users,
            at: userFriend.uid
        )

        let uidNotification = UUID()

        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .friendRequest,
                timestamp: Date(),
                uidUserNotif: user.uid,
                uidEvent: "",
                titleEvent: "Become friends",
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: [userFriend.uid],
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes conv ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )
    }
    
    private func acceptFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: [
                "sentFriendRequests": FieldValue.arrayRemove([user.uid]),
                "friends": FieldValue.arrayUnion([user.uid])
            ],
            to: .users,
            at: userFriend.uid
        )
        
        firebaseService.updateDataByID(
            data: [
                "requestsFriends": FieldValue.arrayRemove([userFriend.uid]),
                "friends": FieldValue.arrayUnion([userFriend.uid])
            ],
            to: .users,
            at: self.user.uid
        )

        let uidNotification = UUID()

        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .acceptedFriendRequest,
                timestamp: Date(),
                uidUserNotif: user.uid,
                uidEvent: "",
                titleEvent: "Accept friends",
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: [userFriend.uid],
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes conv ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )
    }

    private func cancelFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: ["requestsFriends": FieldValue.arrayRemove([user.uid])],
            to: .users,
            at: userFriend.uid
        )
        
        firebaseService.updateDataByID(
            data: ["sentFriendRequests": FieldValue.arrayRemove([userFriend.uid])],
            to: .users,
            at: self.user.uid
        )
    }
    
    private func removeFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: [
                "friends": FieldValue.arrayRemove([user.uid]),
            ],
            to: .users,
            at: userFriend.uid
        )
        
        firebaseService.updateDataByID(
            data: [
                "friends": FieldValue.arrayRemove([userFriend.uid]),
            ],
            to: .users,
            at: self.user.uid
        )
    }
    
    func removeRequestFriend(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: [
                "sentFriendRequests": FieldValue.arrayRemove([user.uid]),
            ],
            to: .users,
            at: userFriend.uid
        )
        
        firebaseService.updateDataByID(
            data: [
                "requestsFriends": FieldValue.arrayRemove([userFriend.uid]),
            ],
            to: .users,
            at: self.user.uid
        )
        
        requestsFriends.remove(userFriend)
    }
}
