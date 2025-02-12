
import Foundation
import SwiftUI

enum AppFont: String {
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
            return .custom(AppFont.GigalypseTrial.rawValue, size: 46)
        case .bodyText:
            return .custom(AppFont.InterRegular.rawValue, size: 16)
        case .buttonLabel:
            return .custom(AppFont.InterSemiBold.rawValue, size: 18)
        }
    }
}
