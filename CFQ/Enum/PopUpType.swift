
import SwiftUI

enum PopUpType {
    case logout
    case removeProfile
    
    var image: ImageResource {
        switch self {
        case .logout:
            return .imageSuspicious
        case .removeProfile:
            return .imageSad
        }
    }
    
    var title: String {
        switch self {
        case .logout:
            return StringsToken.Popup.TitleLogOut
        case .removeProfile:
            return StringsToken.Popup.TitleRemoveAccount
        }
    }
    
    var titleButtonNo: String {
        switch self {
        case .logout:
            return StringsToken.Popup.TitleButtonNoLogOut
        case .removeProfile:
            return StringsToken.Popup.TitleButtonNoRemoveAccount
        }
    }
    
    var titleButtonYes: String {
        switch self {
        case .logout:
            return StringsToken.Popup.TitleButtonYesLogout
        case .removeProfile:
            return StringsToken.Popup.TitleButtonYesRemoveAccount
        }
    }
}
