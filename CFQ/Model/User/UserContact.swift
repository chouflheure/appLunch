import Foundation

class UserContact: Codable, Hashable {
    var uid: String
    var name: String
    var pseudo: String
    var profilePictureUrl: String
    var isActive: Bool

    init(
        uid: String = "",
        name: String = "",
        pseudo: String = "",
        profilePictureUrl: String = "",
        isActive: Bool = false
    ) {
        self.uid = uid
        self.name = name
        self.pseudo = pseudo
        self.profilePictureUrl = profilePictureUrl
        self.isActive = isActive
    }

    // Conformité à Equatable
    static func == (lhs: UserContact, rhs: UserContact) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.name == rhs.name &&
               lhs.pseudo == rhs.pseudo &&
               lhs.profilePictureUrl == rhs.profilePictureUrl &&
               lhs.isActive == rhs.isActive
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(pseudo)
        hasher.combine(profilePictureUrl)
        hasher.combine(isActive)
    }
    
    func userContactDefault() -> [UserContact] {
        return [
            UserContact(
                uid: "",
                name: "",
                pseudo: "",
                profilePictureUrl: "",
                isActive: false
            )
        ]
    }
    
    var printObject: String {
        return "@@@ ---------USER CONTACT---------- \n"
        + "@@@ uid : \(uid) \n"
        + "@@@ name : \(name) \n"
        + "@@@ pseudo : \(pseudo) \n"
        + "@@@ profilePictureUrl : \(profilePictureUrl) \n"
        + "@@@ isActive : \(isActive) \n"
        + "@@@ ------------------"
    }
}
