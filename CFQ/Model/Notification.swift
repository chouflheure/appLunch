
import Foundation
import SwiftUI

class Notification: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var typeNotif: String
    @Published var timestamp: Date
    @Published var userContact: UserContact

    enum CodingKeys: String, CodingKey {
        case uid
        case typeNotif
        case timestamp
        case userContact
    }

    init(
        uid: String,
        typeNotif: String,
        timestamp: Date,
        userContact: UserContact
    ) {
        self.uid = uid
        self.typeNotif = typeNotif
        self.timestamp = timestamp
        self.userContact = userContact
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        typeNotif = try values.decode(String.self, forKey: .typeNotif)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        userContact = try values.decode(UserContact.self, forKey: .userContact)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(typeNotif, forKey: .typeNotif)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(userContact, forKey: .userContact)
    }
    
    var printObject: String {
        return "@@@ ---------Notif---------- "
        + "@@@ \nuid : \(uid)"
        + "@@@ \n typeNotif : \(typeNotif)"
        + "@@@ \n timestamp : \(timestamp)"
        + "@@@ \n userContact : \(userContact)"
        + "@@@ \n ------------------"
    }
}
