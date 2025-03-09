import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var uidUser = String()
    @Published var phoneNumber = String()
    @Published var verificationID = String()
    @Published var isUserExist = false
    @Published var isSignFinish = false
    @Published var hasAlreadyAccount = false
    @Published var isConfirmScreenActive = false
    private let firebaseService = FirebaseService()
    @Published var user: User? = nil

    func toggleHasAlreadyAccount() {
        hasAlreadyAccount.toggle()
    }

    private func closeConfirmScreen() {
        self.isConfirmScreenActive = false
        self.isSignFinish = true
    }

    private func getUserWithIDConnexion(uid: String) {
        print("@@@ here")
        firebaseService.getDataByID(from: .users, with: uid) { (result: Result<User, Error>) in
            print("@@@ result = \(result)")
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
                    print("@@@ Nouvel utilisateur.")
                    self.uidUser = authResult.user.uid
                    print("@@@ UID: \(self.uidUser)")
                    // self.isUserExist = false
                    // self.closeConfirmScreen()
                    // TODO: - edit pour éviter l'appel inutil à firebase
                    self.getUserWithIDConnexion(uid: authResult.user.uid)
                } else {
                    print("@@@ Utilisateur existant.")
                    self.getUserWithIDConnexion(uid: authResult.user.uid)
                }
            }
            
            self.uidUser = authResult?.user.uid ?? ""
        }
    }

    func dontReciveVerificationCode(
        completion: @escaping (Bool, String) -> Void
    ) {
        sendVerificationCode { (success, message) in
            completion(success, message)
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
