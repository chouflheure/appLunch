
import SwiftUI

enum UsersAreFriendsStatusType {
    case noFriend
    case requested
    case friend
    case sendRequested
    case myProfile

    var icon: ImageResource {
        switch self {
        case .noFriend:
            return .iconAddfriend
        case .requested:
            return .iconPendingfriend
        case .friend:
            return .iconFriendadded
        case .sendRequested:
            return .iconFriendadded
        case .myProfile:
            return .iconBug
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .noFriend, .sendRequested, .requested, .myProfile:
            return .clear
        case .friend:
            return .white
        }
    }

    var backgroungColorIcon: Color {
        switch self {
        case .noFriend:
            return .purpleDark
        case .sendRequested:
            return .gray
        case .friend, .myProfile:
            return .clear
        case .requested:
            return .green
        }
    }
}
