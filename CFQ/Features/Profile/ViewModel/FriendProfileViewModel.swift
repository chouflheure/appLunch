
import Foundation
import Firebase
import SwiftUI

class FriendProfileViewModel: ObservableObject {
    @Published var isShowingSettingsView: Bool = false
    @Published var isShowRemoveFriends: Bool = false
    @Published var isPrivateAccount: Bool = false
    @Published var user: User
    @Published var userFriend: User
    @Published var turns: [Turn] = []
    @ObservedObject var coordinator: Coordinator

    var firebaseService = FirebaseService()

    @Published var statusFriend: UsersAreFriendsStatusType = .noFriend {
        didSet {
            handleStatusChange()
        }
    }
    
    var friendsInCommun: [UserContact] {
        guard let contacts = userFriend.userFriendsContact else { return [] }
        let commonIds = Set(user.friends).intersection(Set(userFriend.friends))
        return contacts.filter { commonIds.contains($0.uid) }
    }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.userFriend = coordinator.profileUserSelected

        guard let user = coordinator.user else {
            self.user = User()
            return
        }

        self.user = user
        
        statusFriendButton()
    }
    
    private func handleStatusChange() {
        if statusFriend != .friend {
            isPrivateAccount = true
        } else {
            isPrivateAccount = false
        }
    }
    
    func turnsInCommun(coordinator: Coordinator) -> [Turn]{
        var turnShowByUser: [Turn] = []
        turns.forEach({ turn in
            if turn.invited.contains(coordinator.user?.uid ?? "id") {
                turnShowByUser.append(turn)
            }
        })
        return turnShowByUser
    }
    
    func statusFriendButton() {
        if user.friends.contains(userFriend.uid) {
            statusFriend = .friend
        } else if user.sentFriendRequests.contains(userFriend.uid) {
            statusFriend = .sendRequested
        } else if user.requestsFriends.contains(userFriend.uid) {
            statusFriend = .requested
        } else {
            statusFriend = .noFriend
        }
    }
    
    func onclickAddFriend() {
        switch statusFriend {
        case .noFriend:
            statusFriend = .sendRequested
            actionOnClickButtonAddFriend(type: .add)
        case .requested:
            statusFriend = .friend
            actionOnClickButtonAddFriend(type: .accept)
        case .sendRequested:
            statusFriend = .noFriend
            actionOnClickButtonAddFriend(type: .cancel)
        case .friend:
            statusFriend = .noFriend
            isShowRemoveFriends = true
        }
    }

    func actionOnClickButtonAddFriend(type: CellFriendPseudoNameActionType) {
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

    private func addFriendsToList(userFriend: User) {
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
    
    private func acceptFriendsToList(userFriend: User) {
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

    private func cancelFriendsToList(userFriend: User) {
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
    
    private func removeFriendsToList(userFriend: User) {
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

extension FriendProfileViewModel {
    func catchAllDataProfileUser(uid: String) {

        firebaseService.getDataByID(
            from: .users,
            with: uid,
            completion: { (result: Result<User, Error>) in
                print("uid = \(uid)")
                switch result {
                case .success(let user):
                DispatchQueue.main.async {
                    self.userFriend = user
                    self.startListeningToTurn(user: user)
                    self.startListeningToUsersFriends(friendsIds: user.friends)
                }
                case .failure(let error):
                    print("@@@ error")
                    print("@@@ error \(error)")
                    Logger.log(error.localizedDescription, level: .error)
                }
            }
        )
    }
   
    private func startListeningToUsersFriends(friendsIds: [String]) {
        firebaseService.getDataByIDs(
            from: .users,
            with: friendsIds
        ){ (result: Result<[UserContact], Error>) in
            switch result {
                case .success(let userContact):
                    DispatchQueue.main.async {
                        self.coordinator.profileUserSelected.userFriendsContact = userContact
                        self.userFriend.userFriendsContact = userContact
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")

                }
            }
    }
    
    func startListeningToTurn(user: User) {
        firebaseService.getDataByIDs(
            from: .turns,
            with: user.postedTurns ?? []
        ) { [weak self] (result: Result<[Turn], Error>) in
            guard let self = self else { return }
            print("@@@ here")
            switch result {
            case .success(let fetchedTurns):
                // Stockez les turns récupérés
                print("@@@ success")
                DispatchQueue.main.async {
                    self.turns = fetchedTurns
                    self.turns.forEach({ turn in
                        turn.adminContact = UserContact(
                            uid: user.uid,
                            name: user.uid,
                            pseudo: user.pseudo,
                            profilePictureUrl: user.profilePictureUrl,
                            isActive: user.isActive
                        )
                    })
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error")
            }
        }
    }
}
