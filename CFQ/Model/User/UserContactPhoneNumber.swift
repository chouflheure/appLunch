
import Foundation

class UserContactPhoneNumber: Codable, Hashable {
    var uid: String
    var name: String
    var pseudo: String
    var phoneNumber: String
    var profilePictureUrl: String

    init(
        uid: String = "",
        name: String = "",
        pseudo: String = "",
        phoneNumber: String = "",
        profilePictureUrl: String = ""
    ) {
        self.uid = uid
        self.name = name
        self.pseudo = pseudo
        self.phoneNumber = phoneNumber
        self.profilePictureUrl = profilePictureUrl
    }

    // Conformité à Equatable
    static func == (lhs: UserContactPhoneNumber, rhs: UserContactPhoneNumber) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.name == rhs.name &&
               lhs.pseudo == rhs.pseudo &&
               lhs.phoneNumber == rhs.phoneNumber &&
               lhs.profilePictureUrl == rhs.profilePictureUrl
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(name)
        hasher.combine(pseudo)
        hasher.combine(phoneNumber)
        hasher.combine(profilePictureUrl)
    }

    var printObject: String {
        return "@@@ --------- User Contact Phone Number ---------- \n"
        + "@@@ uid : \(uid) \n"
        + "@@@ name : \(name) \n"
        + "@@@ pseudo : \(pseudo) \n"
        + "@@@ phoneNumber : \(phoneNumber) \n"
        + "@@@ profilePictureUrl : \(profilePictureUrl) \n"
        + "@@@ ------------------"
    }
}
