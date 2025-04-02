
import SwiftUI

enum UsersAreFriendsStatusType {
    case noFriend
    case requested
    case friend

    var icon: ImageResource {
        switch self {
        case .noFriend:
            return .iconAddfriend
        case .requested:
            return .iconPendingfriend
        case .friend:
            return .iconFriendadded
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .noFriend, .requested:
            return .clear
        case .friend:
            return .white
        }
    }

    var backgroungColorIcon: Color {
        switch self {
        case .noFriend:
            return .purpleDark
        case .requested:
            return .gray
        case .friend:
            return .clear
        }
    }
}
