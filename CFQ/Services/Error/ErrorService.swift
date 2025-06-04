import Firebase
import FirebaseAuth
import Foundation

class ErrorService {

    func errorAuthFirebase(error: Error) -> String {
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
