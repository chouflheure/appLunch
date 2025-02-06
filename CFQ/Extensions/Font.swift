
import Foundation
import SwiftUI

enum AppFont: String {
    case GigalypseTrial = "GigalypseTrial-Regular.otf"
    case InterBold = "Inter-Bold.otf"
    case InterMedium = "Inter-Medium.otf"
    case InterRegular = "Inter-Regular.otf"
    case InterSemiBold = "Inter-SemiBold.otf"
    case InterLight  = "Inter-Light.otf"

    func font(size: CGFloat) -> Font {
        return .custom(self.rawValue, size: size)
    }
}
