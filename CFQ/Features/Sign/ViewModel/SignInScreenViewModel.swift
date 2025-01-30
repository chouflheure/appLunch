import Foundation
import FirebaseAuth

class SignInScreenViewModel: ObservableObject {
    @Published var hasAlreadyAccount = false
    @Published var isConfirmScreenActive: Bool = false
    @Published var isSignUpScreenActive: Bool = false
    @Published var phoneNumber = String()
    @Published var verificationID = String()

    func goToConfirmCode() {
        isConfirmScreenActive = true
    }

    func toggleHasAlreadyAccount() {
        hasAlreadyAccount.toggle()
    }

    func sendVerificationCode() {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Erreur: \(error.localizedDescription)")
                return
            }
            if let verificationID = verificationID {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.goToConfirmCode()
            }
        }
    }
    
    func errorCodeValidation() {}
    
    func errorTimeOutCode() {}
}

