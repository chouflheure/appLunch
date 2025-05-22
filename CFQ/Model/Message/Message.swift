
import Foundation
import SwiftUI

class Message: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var message: String
    @Published var senderUID: String
    @Published var timestamp: Date
    @Published var userContact: UserContact?

    enum CodingKeys: String, CodingKey {
        case uid
        case message
        case senderUID
        case timestamp
        case userContact
    }

    init(
        uid: String,
        message: String,
        senderUID: String,
        timestamp: Date,
        userContact: UserContact?
    ) {
        self.uid = uid
        self.message = message
        self.senderUID = senderUID
        self.timestamp = timestamp
        self.userContact = userContact
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        message = try values.decode(String.self, forKey: .message)
        senderUID = try values.decode(String.self, forKey: .senderUID)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        userContact = try values.decodeIfPresent(UserContact.self, forKey: .userContact)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(message, forKey: .message)
        try container.encode(senderUID, forKey: .senderUID)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(userContact, forKey: .userContact)
    }
    
    var printObject: String {
        return "@@@ ---------Message---------- "
        + "\n @@@ uid : \(uid)"
        + "\n @@@ message : \(message)"
        + "\n @@@ senderUID : \(senderUID)"
        + "\n @@@ timestamp : \(timestamp)"
        + "\n @@@ userContact : \(userContact)"
        + "\n ------------------"
    }
}
