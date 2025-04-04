
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
    case Title_Inter_semibold_24
    case Title_Gigalypse_24
    case Title_Gigalypse_20
    case Label_Inter_Semibold_16
    case Placeholder_Inter_Regular_16
    case Label_Inter_Semibold_14
    case Label_Inter_Medium_12
    case Label_Gigalypse_12
    case Body_Inter_Medium_16
    case Body_Inter_Regular_16
    case Body_Inter_Medium_14
    case Body_Inter_Regular_14
    case Body_Inter_Semibold_12
    case Body_Inter_Medium_12
    case Body_Inter_Regular_12
    case Body_Inter_Regular_10
    
    func font() -> Font {
        switch self {
        case .Title_Inter_semibold_24:
            return .custom(FontType.InterSemiBold.rawValue, size: 24)
        case .Title_Gigalypse_24:
            return .custom(FontType.GigalypseTrial.rawValue, size: 24)
        case .Title_Gigalypse_20:
            return .custom(FontType.GigalypseTrial.rawValue, size: 20)
        case .Label_Inter_Semibold_16:
            return .custom(FontType.InterSemiBold.rawValue, size: 16)
        case .Placeholder_Inter_Regular_16:
            return .custom(FontType.InterRegular.rawValue, size: 16)
        case .Label_Inter_Semibold_14:
            return .custom(FontType.InterSemiBold.rawValue, size: 14)
        case .Label_Inter_Medium_12:
            return .custom(FontType.InterMedium.rawValue, size: 12)
        case .Label_Gigalypse_12:
            return .custom(FontType.GigalypseTrial.rawValue, size: 14)
        case .Body_Inter_Medium_16:
            return .custom(FontType.InterMedium.rawValue, size: 16)
        case .Body_Inter_Regular_16:
            return .custom(FontType.InterRegular.rawValue, size: 16)
        case .Body_Inter_Medium_14:
            return .custom(FontType.InterMedium.rawValue, size: 14)
        case .Body_Inter_Regular_14:
            return .custom(FontType.InterRegular.rawValue, size: 14)
        case .Body_Inter_Semibold_12:
            return .custom(FontType.InterSemiBold.rawValue, size: 12)
        case .Body_Inter_Medium_12:
            return .custom(FontType.InterMedium.rawValue, size: 12)
        case .Body_Inter_Regular_12:
            return .custom(FontType.InterRegular.rawValue, size: 12)
        case .Body_Inter_Regular_10:
            return .custom(FontType.InterRegular.rawValue, size: 10)
        }
    }
    
    func color() -> Color {
        switch self {
        case .Body_Inter_Medium_12,
                .Body_Inter_Medium_14,
                .Body_Inter_Medium_16,
                .Label_Inter_Semibold_14,
                .Label_Inter_Semibold_16,
                .Label_Inter_Medium_12,
                .Label_Gigalypse_12,
                .Title_Inter_semibold_24,
                .Title_Gigalypse_24,
                .Title_Gigalypse_20,
                .Body_Inter_Regular_16,
                .Body_Inter_Regular_14,
                .Body_Inter_Semibold_12,
                .Body_Inter_Regular_10 :
            return .whitePrimary
        case .Placeholder_Inter_Regular_16, .Body_Inter_Regular_12:
            return .whiteTertiary
        }
    }
}
