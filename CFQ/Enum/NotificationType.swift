
import SwiftUI

enum NotificationType: CaseIterable {
    case message
    case invitTurn
    case invitCFQ
    case invitFriends
    case askDaily
    
    var title: String {
        switch self {
        case .message:
            return "Messagerie"
        case .invitTurn:
            return "Invitation aux events"
        case .invitCFQ:
            return "Invitation au CFQ"
        case .invitFriends:
            return "Invitation de groupe"
        case .askDaily:
            return "Notif quotidiennes"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .message:
            return .iconMessagerie
        case .invitTurn:
            return .iconMoodNightClub
        case .invitCFQ:
            return .iconBroadcast
        case .invitFriends:
            return .iconNavTeamFilled
        case .askDaily:
            return .iconNotifs
        }
    }
    
    var topic: String {
        switch self {
        case .message:
            return "new_message"
        case .invitTurn:
            return "invitTurn"
        case .invitCFQ:
            return "invitCFQ"
        case .invitFriends:
            return "invitFriends"
        case .askDaily:
            return "daily_ask_turn"
        }
    }
}
