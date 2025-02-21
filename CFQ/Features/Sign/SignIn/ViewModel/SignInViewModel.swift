import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var hasAlreadyAccount = false
    @Published var isConfirmScreenActive: Bool = false
    @Published var isSignFinish: Bool = false
    @Published var isSignUpScreenActive: Bool = false
    @Published var phoneNumber = String()
    @Published var verificationID = String()
    private let firebaseService = FirebaseService()
    @Published var showNewPage: Bool = false
    @Published var isUserExist: Bool = false

    private func goToConfirmCode() {
        isConfirmScreenActive = true
    }

    func toggleHasAlreadyAccount() {
        hasAlreadyAccount.toggle()
    }

    private func getUserWithIDConnexion(uid: String) -> Bool {
        var isUserExist: Bool = false
        self.isSignFinish = true
        
        firebaseService.getDataByID(from: .users, whith: uid) {
            (result: Result<User, Error>) in
            switch result {
            case .success(let user):
                isUserExist = true
                return
            case .failure(let error):
                isUserExist = false
                return
            }
        }
        return isUserExist
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
                    verificationID, forKey: "authVerificationID")
                self.goToConfirmCode()
            }
        }
    }

    func verifyCode(
        for verificationCode: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        let verificationID =
            UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(false, self.errorAuthFirebase(error: error))
                return
            }

            if let user = Auth.auth().currentUser {
                let uid = user.uid
                Logger.log("Connexion réussie - UID: \(uid)", level: .success)
                let isUserExist = self.getUserWithIDConnexion(uid: uid)
                if isUserExist {
                    completion(true, "")
                } else {
                    // completion(false, "")
                    completion(true, "")
                }
            }
        }
    }

    func dontReciveVerificationCode(
        completion: @escaping (Bool, String) -> Void
    ) {
        sendVerificationCode { (success, message) in
            print("@@@ success = \(success)")
            print("@@@ message = \(message)")
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
