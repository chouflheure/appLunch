
import Foundation
import SwiftUI

class SignCoordinator: ObservableObject {
    @Published var currentView: AnyView?
    @Published var isConfirmScreenActive: Bool = false
    @Published var isSignUpScreenActive: Bool = false
    
    func goToConfirmCode() {
        isConfirmScreenActive = true
    }
    
}
