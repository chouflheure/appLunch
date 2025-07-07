
import Foundation
import SwiftUI

enum NotificationsType: String {
    case teamCreated = "teamCreated"
    case friendRequest = "friendRequest"
    case acceptedFriendRequest = "acceptedFriendRequest"
    case cfqCreated = "cfqCreated"
    case turnCreated = "turnCreated"
    case attending = "attending"
    
    func bodyNotif() -> String {
        switch self {
        case .turnCreated:
            "t'invite à son turn "
        case .teamCreated:
            "t'a ajouté la team "
        case .friendRequest:
            "te demande en ami "
        case .acceptedFriendRequest:
            ""
        case .cfqCreated:
            " demande "
        case .attending:
            "participe à ton event "
        }
    }
}

class Notification: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var typeNotif: String
    @Published var timestamp: Date
    @Published var uidUserNotif: String
    @Published var uidEvent: String
    @Published var titleEvent: String
    @Published var userInitNotifPseudo: String
    @Published var userContact: UserContact?

    enum CodingKeys: String, CodingKey {
        case uid
        case typeNotif
        case timestamp
        case uidUserNotif
        case uidEvent
        case titleEvent
        case userInitNotifPseudo
        case userContact
    }

    init(
        uid: String,
        typeNotif: NotificationsType,
        timestamp: Date,
        uidUserNotif: String,
        uidEvent: String,
        titleEvent: String,
        userInitNotifPseudo: String,
        userContact: UserContact? = nil
    ) {
        self.uid = uid
        self.typeNotif = typeNotif.rawValue
        self.timestamp = timestamp
        self.uidUserNotif = uidUserNotif
        self.uidEvent = uidEvent
        self.titleEvent = titleEvent
        self.userInitNotifPseudo = userInitNotifPseudo
        self.userContact = userContact
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        typeNotif = try values.decode(String.self, forKey: .typeNotif)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        uidUserNotif = try values.decode(String.self, forKey: .uidUserNotif)
        uidEvent = try values.decode(String.self, forKey: .uidEvent)
        titleEvent = try values.decode(String.self, forKey: .titleEvent)
        userInitNotifPseudo = try values.decode(String.self, forKey: .userInitNotifPseudo)
        userContact = try values.decodeIfPresent(UserContact.self, forKey: .userContact)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(typeNotif, forKey: .typeNotif)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(uidUserNotif, forKey: .uidUserNotif)
        try container.encode(uidEvent, forKey: .uidEvent)
        try container.encodeIfPresent(titleEvent, forKey: .titleEvent)
        try container.encodeIfPresent(userInitNotifPseudo, forKey: .userInitNotifPseudo)
        try container.encodeIfPresent(userContact, forKey: .userContact)
    }
    
    var printObject: String {
        return "@@@ ---------Notif---------- "
        + "\n @@@ uid : \(uid)"
        + "\n @@@ typeNotif : \(typeNotif)"
        + "\n @@@ timestamp : \(timestamp)"
        + "\n @@@ userContact : \(String(describing: userContact))"
        + "\n @@@ ------------------"
    }
}
