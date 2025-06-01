
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
    var user: User
    private var allFriends = Set<UserContact>()

    @Published var friendsList = Set<UserContact>()

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
        } else {
            return .add
        }
    }
}

extension AddFriendsViewModel {
    
    func fecthAllUsers() {
        firebaseService.getAllData(from: .users) { (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                self.friendsList = Set(users)
                self.allFriends = Set(users)
                // completion(users)
            case .failure(let error):
                print("- Erreur :", error.localizedDescription)
            }
        }
    }

    func addFriendsToList(userFriend: UserContact) {
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

    func cancelFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: ["requestsFriends": FieldValue.arrayRemove([userFriend.uid])],
            to: .users,
            at: userFriend.uid
        )
    }
}
