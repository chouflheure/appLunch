
import Foundation
import SwiftUI

private enum FontType: String {
    case GigalypseTrial = "GigalypseTrial-Regular"
    case InterBold = "Inter-Bold"
    case InterMedium = "Inter-Medium"
    case InterRegular = "Inter-Regular"
    case InterSemiBold = "Inter-SemiBold"
    case InterLight  = "Inter-Light"
}

enum FontToken {
    case titleCardTurn
    case bodyText
    case buttonLabel

    func font() -> Font {
        switch self {
        case .titleCardTurn:
            return .custom(FontType.GigalypseTrial.rawValue, size: 24)
        case .bodyText:
            return .custom(FontType.InterRegular.rawValue, size: 16)
        case .buttonLabel:
            return .custom(FontType.InterSemiBold.rawValue, size: 18)
        }
    }

    func color() -> Color {
        switch self {
        case .titleCardTurn:
            return .blue
        case .bodyText:
            return .gray
        case .buttonLabel:
            return .white
        }
    }

    func isBold() -> Bool {
        switch self {
        case .titleCardTurn, .buttonLabel:
            return true
        case .bodyText:
            return false
        }
    }
}
