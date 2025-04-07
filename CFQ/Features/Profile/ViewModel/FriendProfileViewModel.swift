
import Foundation

class FriendProfileViewModel: ObservableObject {
    @Published var isShowingSettingsView: Bool = false
    @Published var isShowRemoveFriends: Bool = false
    @Published var hasfriendUserWithThisProfile: Bool = false
    @Published var isPrivateAccount: Bool = false
    @Published var isRequestedToBeFriendByTheUser: Bool = false

    @Published var statusFriend: UsersAreFriendsStatusType = .noFriend {
        didSet {
            handleStatusChange()
        }
    }

    private func handleStatusChange() {
        if statusFriend != .friend {
            isPrivateAccount = true
        } else {
            isPrivateAccount = false
        }
    }

    func statusFriendButton(user: User, friend: User) {
        if user.friends.contains(friend.uid) {
            statusFriend = .friend
        } else if user.requestsFriends.contains(friend.uid) {
            statusFriend = .requested
        } else if friend.requestsFriends.contains(user.uid) {
            isRequestedToBeFriendByTheUser = true
        } else {
            statusFriend = .noFriend
        }
    }
    
    func onclickAddFriend() {
        switch statusFriend {
        case .noFriend:
            statusFriend = .requested
            isRequestedToBeFriendByTheUser = false
        case .requested:
            statusFriend = .noFriend
            isRequestedToBeFriendByTheUser = false
        case .friend:
            statusFriend = .noFriend
            isShowRemoveFriends = true
        }
    }

    func becomeFriend(answer: Bool) {
        if answer {
            statusFriend = .friend
        } else {
            statusFriend = .noFriend
        }
        isRequestedToBeFriendByTheUser = false
    }
    
}
