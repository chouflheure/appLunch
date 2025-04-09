import Foundation

class UserContact: Codable, Hashable {
    var uid: String
    var name: String
    var firstName: String
    var pseudo: String
    var profilePictureUrl: String

    init(
        uid: String,
        name: String,
        firstName: String,
        pseudo: String,
        profilePictureUrl: String
    ) {
        self.uid = uid
        self.name = name
        self.firstName = firstName
        self.pseudo = pseudo
        self.profilePictureUrl = profilePictureUrl
    }

    // Conformité à Equatable
    static func == (lhs: UserContact, rhs: UserContact) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.name == rhs.name &&
               lhs.firstName == rhs.firstName &&
               lhs.pseudo == rhs.pseudo &&
               lhs.profilePictureUrl == rhs.profilePictureUrl
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(firstName)
        hasher.combine(pseudo)
        hasher.combine(profilePictureUrl)
    }
}
