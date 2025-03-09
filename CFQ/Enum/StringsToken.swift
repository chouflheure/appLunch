import SwiftUI

enum StringsToken {
    enum Sign {
        // LogScreen
        static let Connexion = "Connexion"
        static let Inscritpion = "Inscription"
        static let ConnectYou = "Connecte-toi"
        static let InscritpionYou = "Inscription-toi"
        static let NoAccount = "Pas encore de compte ?"
        static let AlreadyAccount = "T’as déjà un compte ?"
        static let PlaceholderPhoneNumber = "06 ..."

        // ConfirmCodeScreen
        static let PlaceholderConfimCode = "123456"
        static let DontReceiveCode = "Je n'ai pas recu le code"
        static let SendConfirmCode = "Envoyez un code"
        static let CheckConfirmCode = "Vérifier le code"
        static let ConfirmationCode = "Confirme ton code"
        
        // Inscription
        static let TitleWhichIsYourIdentifier = "Ton petit nom"
        static let TitleWhichIsYourBirthday = "Quel est ta date d'anniversarie"
        static let TitleWhichIsYourLocalisation = "T'es où ?"
        static let TitleFindYourFriends = "Trouve tes amis"
        static let TitleAddPicture = "ta photo"
        static let TitleBackStep = "Revenir en arrière"
        static let Next = "Next"
        static let Back = "Back"
        static let BackToSign = "Retour à l'inscription"
        static let WelcomeToCFQ = "Bienvenue sur CFQ 🎉"
        static let AlmostThere = "Tu y es presque"
    }

    enum Popup {
        static let TitleRemoveAccount = "Tu supprimer ton compte ?"
        static let TitleLogOut = "Tu veux te déconnecter ?"
        static let TitleButtonNoLogOut = "Nop, je reste"
        static let TitleButtonYesLogout = "Yes, ciao"
        static let TitleButtonNoRemoveAccount = "Nop, je garde"
        static let TitleButtonYesRemoveAccount = "Yes, ça dégage"
    }

    enum Profile {
        static let Friends = "Amis"
    }
    
    enum Settings {
        static let edit = "Modifier"
        static let headereditMyProfil = "Modifier mon profil"
        static let onboardingPreview = "Guide d'utilisation"
        static let aBugTellUs = "Un bug, une remarque ? Dis nous tout !"
        static let notifications = "Gérer mes notifs"
        static let logOut = "Se deconnecter"
        static let deleteAccount = "Supprimer mon compte"
        static let shareReport = "Envoyer vos retours 💌"
        static let subject = "Feedback"
        static let adressForMail = "cfq.hq.25@gmail.com"
        static let headerABug = "Un bug, une remarque"
        static let headerNotifications = "Notifications"
    }
    
    enum ButtonTitle {
        static let GoBackLogin = "Revenir en arrière"
        static let GoNextLogin = "Suivant"
    }
    
    enum TurnCardInformation {
        static let PlaceholderTitle = "Nom de l'évenement"
    }
    
    enum AddFriend {
        static let guest = "Invités"
    }
    
    enum AttentingGuest {}
    
    enum CFQ {}
    
    enum Feed {}
    
    enum Map {}
    
    enum Messaging {}
    
    enum Notification {}
    
    enum Team {}
    
    enum Turn {}
}

