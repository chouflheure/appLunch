
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
    case SpecialTitles_White_Bold
    case H1_White
    case H2_White
    case H3_White
    
    func font() -> Font {
        switch self {
        case .SpecialTitles_White_Bold:
            return .custom(FontType.GigalypseTrial.rawValue, size: 24)
        case .H1_White:
            return .custom(FontType.InterBold.rawValue, size: 32)
        case .H2_White:
            return .custom(FontType.InterBold.rawValue, size: 24)
        case .H3_White:
            return .custom(FontType.InterBold.rawValue, size: 18)
        }
    }
    
    func color() -> Color {
        switch self {
        case .SpecialTitles_White_Bold, .H1_White, .H2_White, .H3_White:
            return .white
        }
    }
}
