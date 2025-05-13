
import SwiftUI

enum LargeButtonType {
    case signNext
    case signBack
    case teamCreate
    case addParticipant
    case settings
    
    var data: LargeButtonData {
        switch self {
        case .signNext, .addParticipant, .settings:
            return LargeButtonData(
                background: .black,
                foregroundColor: .white,
                hasStoke: true
            )
        case .signBack:
            return LargeButtonData(
                background: .clear,
                foregroundColor: .purpleLight,
                hasStoke: false
            )
        case .teamCreate:
            return LargeButtonData(
                background: .white,
                foregroundColor: .black,
                hasStoke: false
            )
        }
    }
}

