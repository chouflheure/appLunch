
import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows.first?.rootViewController?.view.endEditing(force)
    }
}
