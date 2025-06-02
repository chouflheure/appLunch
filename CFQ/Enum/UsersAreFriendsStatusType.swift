
import SwiftUI

enum UsersAreFriendsStatusType {
    case noFriend
    case requested
    case friend
    case sendRequested

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
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .noFriend, .sendRequested, .requested:
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
        case .friend:
            return .clear
        case .requested:
            return .green
        }
    }
}
