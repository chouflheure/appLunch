import Foundation
import SwiftUI
import Combine

class UserContact: ObservableObject, Encodable, Decodable, Hashable, Equatable {
    @Published var uid: String
    @Published var name: String
    @Published var pseudo: String
    @Published var profilePictureUrl: String
    @Published var isActive: Bool

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

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case pseudo
        case profilePictureUrl
        case isActive
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        name = try values.decode(String.self, forKey: .name)
        pseudo = try values.decode(String.self, forKey: .pseudo)
        profilePictureUrl = try values.decode(String.self, forKey: .profilePictureUrl)
        isActive = try values.decode(Bool.self, forKey: .isActive)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encode(pseudo, forKey: .pseudo)
        try container.encode(profilePictureUrl, forKey: .profilePictureUrl)
        try container.encode(isActive, forKey: .isActive)
    }
    
    // ✅ IMPLÉMENTATION DE HASHABLE
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid) // Utilise l'uid comme identificateur unique
    }
    
    // ✅ IMPLÉMENTATION DE EQUATABLE
    static func == (lhs: UserContact, rhs: UserContact) -> Bool {
        return lhs.uid == rhs.uid // Deux UserContact sont égaux s'ils ont le même uid
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
