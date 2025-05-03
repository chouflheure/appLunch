import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var uidUser = String()
    @Published var phoneNumber = String()
    @Published var verificationID = String()
    @Published var user: User? = nil
    @Published var isUserExist = false
    @Published var isSignFinish = false
    @Published var hasAlreadyAccount = false
    @Published var isConfirmScreenActive = false
    @Published var isEnabledResendCode: Bool = false
    @Published var numberTapResendCode: Int = 0

    @State private var timer: Timer? = nil

    private let firebaseService = FirebaseService()

    func signInGuestMode() {
        isSignFinish = true
        isUserExist = true
        user = User().guestMode
    }

    private func closeConfirmScreen() {
        self.isConfirmScreenActive = false
        self.isSignFinish = true
        UserDefaults.standard.set(user?.uid, forKey: "userUID")
    }

    private func getUserWithIDConnexion(uid: String) {
        firebaseService.getDataByID(from: .users, with: uid) { (result: Result<User, Error>) in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.user = user
                    self.isUserExist = true
                    self.closeConfirmScreen()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.user = nil
                    self.isUserExist = false
                    self.closeConfirmScreen()
                }
            }
        }
    }

    private func formatPhoneNumber(for phoneNumber: String) -> String {
        var formattedNumber = phoneNumber

        if formattedNumber.hasPrefix("0") {
            formattedNumber = "+33" + formattedNumber.dropFirst()
        }

        return formattedNumber
    }

    func sendVerificationCode(completion: @escaping (Bool, String) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(
            formatPhoneNumber(for: phoneNumber), uiDelegate: nil
        ) { verificationID, error in
            if let error = error {
                completion(false, self.errorAuthFirebase(error: error))
                return
            }
            if let verificationID = verificationID {
                UserDefaults.standard.set(
                    verificationID,
                    forKey: "authVerificationID"
                )
                self.isConfirmScreenActive = true
                completion(true, "")
            }
        }
    }

    func verifyCode(
        for verificationCode: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(false, self.errorAuthFirebase(error: error))
                return
            }

            if let authResult = authResult {
                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                if isNewUser {
                    self.uidUser = authResult.user.uid
                    self.isUserExist = false
                    self.closeConfirmScreen()
                } else {
                    self.uidUser = authResult.user.uid
                    self.getUserWithIDConnexion(uid: authResult.user.uid)
                }
            }
        }
    }

    func dontReciveVerificationCode(
        completion: @escaping (Bool, String) -> Void
    ) {
        if numberTapResendCode >= 3 {
            startTimerLock10m()
            completion(false, "Vous avez tenté de réenvoyer le code 3 fois. Veuillez patienter 10 minutes avant de réessayer.")
            return
        } else {
            sendVerificationCode { (success, message) in
                if success {
                    self.numberTapResendCode += 1
                }
                completion(success, message)
            }
        }
    }

    func startTimerLock10m() {
        isEnabledResendCode = false
        let delay = 600.0
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.isEnabledResendCode = true
            self.numberTapResendCode = 0
        }
    }

    func startTimer10s() {
        isEnabledResendCode = false
        let delay = 10.0
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            self.isEnabledResendCode = true
        }
    }

    private func errorAuthFirebase(error: Error) -> String {
        let errorCode = (error as NSError).code
        let errorMessage: String

        switch errorCode {
        case AuthErrorCode.invalidPhoneNumber.rawValue:
            errorMessage = "Le numéro de téléphone n'est pas valide."
        case AuthErrorCode.missingPhoneNumber.rawValue:
            errorMessage = "Le numéro de téléphone est manquant."
        case AuthErrorCode.quotaExceeded.rawValue:
            errorMessage = "Quota dépassé pour l'envoi de messages."
        case AuthErrorCode.tooManyRequests.rawValue:
            errorMessage = "Trop de tentatives de connexion."
        case AuthErrorCode.invalidVerificationCode.rawValue:
            errorMessage = "Le code de vérification est invalide."
        case AuthErrorCode.expiredActionCode.rawValue:
            errorMessage = "Le code de vérification a expiré."
        case AuthErrorCode.userDisabled.rawValue:
            errorMessage = "L'utilisateur a été désactivé."
        case AuthErrorCode.userNotFound.rawValue:
            errorMessage = "Utilisateur non trouvé."
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            errorMessage = "Un compte existe déjà avec un autre type de connexion."
        case AuthErrorCode.internalError.rawValue:
            errorMessage = "Erreur interne du serveur."
        default:
            if errorCode == 17020 {
                print("Erreur réseau : \(error.localizedDescription)")
                errorMessage = "Problème de connexion internet"
            } else {
                errorMessage = "Une erreur inconnue est survenue."
            }
        }

        Logger.log(errorMessage, level: .error)

        return errorMessage
    }
}
