
import Foundation
import Firebase
import SwiftUI

class FriendProfileViewModel: ObservableObject {
    @Published var isShowingSettingsView: Bool = false
    @Published var isShowRemoveFriends: Bool = false
    @Published var isPrivateAccount: Bool = false
    @Published var user: User
    @Published var userFriend: User
    var firebaseService = FirebaseService()
    
    @Published var statusFriend: UsersAreFriendsStatusType = .noFriend {
        didSet {
            handleStatusChange()
        }
    }

    init(coordinator: Coordinator) {
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
