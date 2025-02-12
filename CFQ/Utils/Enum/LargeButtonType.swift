
import SwiftUI

enum LargeButtonType {
    case signNext
    case signBack
    case teamCreate
    case addParticipant
    
    var data: LargeButtonData {
        switch self {
        case .signNext, .addParticipant:
            return LargeButtonData(
                background: .black,
                foregroundColor: .white,
                hasStoke: true
            )
        case .signBack:
            return LargeButtonData(
                background: .clear,
                foregroundColor: .purple,
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

