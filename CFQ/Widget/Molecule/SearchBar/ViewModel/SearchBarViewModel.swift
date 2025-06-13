import SwiftUI
import Firebase

class SearchBarViewModel: ObservableObject {

    var firebaseService = FirebaseService()
    @ObservedObject var coordinator: Coordinator
    @Published var user: User
    @Published var friendsList: Set<UserContact>
    @Published var requestsFriends: Set<UserContact>
    @Published var researchText = String()

    private var allFriends = Set<UserContact>()

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.pseudo.lowercased().hasPrefix(word) || name.name.lowercased().hasPrefix(word)
            }
        }
    }
    
    init(coordinator: Coordinator, friendsList: Set<UserContact>, requestsFriends: Set<UserContact>) {
        self.coordinator = coordinator
        guard let user = coordinator.user else {
            self.user = User()
            self.friendsList = []
            self.requestsFriends = []
            print("@@@ here error")
            return
        }
        print("@@@ here good")
        self.user = user
        self.friendsList = friendsList
        self.requestsFriends = requestsFriends
        self.allFriends = friendsList
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        friendsList = allFriends
        friendsList = filteredNames
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
                uidUserNotif: userFriend.uid,
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
            data:
                [
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
                uidUserNotif: userFriend.uid,
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
    
}
