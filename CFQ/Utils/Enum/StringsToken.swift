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
        static let TitleWhichIsYourIdentifier = "Quel est ton identifiant"
        static let TitleWhichIsYourBirthday = "Quel est ta date d'anniversarie"
        static let TitleFindYourFriends = "Trouve tes amis"
        static let TitleAddPicture = "Petite photo"
        static let TtitleBackStep = "Revenir en arrière"
    }

    enum Profile {
        static let Friends = "Amis"
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

