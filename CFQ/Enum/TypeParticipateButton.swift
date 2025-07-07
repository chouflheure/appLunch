
import SwiftUI

enum TypeParticipateButton: String {
    case yes
    case no
    case maybe
    case none
    case yourEvent

    var iconTypeParticipate: String {
        switch self {
        case .yes:
            return "👍"
        case .no:
            return "👎"
        case .maybe:
            return "🤔"
        case .none, .yourEvent:
            return ""
        }
    }

    var titleTypeParticipate: String {
        switch self {
        case .yes:
            return "Là"
        case .no:
            return "Pas là"
        case .maybe:
            return "Jsais pas"
        case .none:
            return ""
        case .yourEvent:
            return "Ton Turn"
        }
    }
}
