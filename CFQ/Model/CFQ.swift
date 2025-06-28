
import Foundation
/*
class CFQ: Codable, Hashable {
    let uid: String
    let title: String
    let admin: String
    let messagerieUUID: String
    let users: [String]
    let participants: [String]?
    
    init(
        uid: String,
        title: String,
        admin: String,
        messagerieUUID: String,
        users: [String],
        participants: [String]?
    ) {
        self.uid = uid
        self.title = title
        self.admin = admin
        self.messagerieUUID = messagerieUUID
        self.users = users
        self.participants = participants
    }
    
    static func == (lhs: CFQ, rhs: CFQ) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.title == rhs.title &&
               lhs.admin == rhs.admin &&
               lhs.messagerieUUID == rhs.messagerieUUID &&
               lhs.users == rhs.users &&
               lhs.participants == rhs.participants
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(title)
        hasher.combine(admin)
        hasher.combine(messagerieUUID)
        hasher.combine(users)
        hasher.combine(participants)
    }
    
    func mockCFQ() -> CFQ {
        return CFQ(
            uid: "MockCFQ",
            title: "CFQ Demo",
            admin: "MockUser",
            messagerieUUID: "MockConv",
            users: ["MockUser"],
            participants: [""]
        )
    }
    
    var printObject: String {
        return "@@@ ---------CFQ---------- "
        + "\nuid : \(uid)"
        + "\n title : \(title)"
        + "\n admin : \(admin)"
        + "\n messagerieUUID : \(messagerieUUID)"
        + "\n users : \(users)"
        + "\n ------------------"
    }
}
*/

class CFQ: ObservableObject, Encodable, Decodable {
    var uid: String
    let title: String
    let admin: String
    let messagerieUUID: String
    let users: [String]
    let timestamp: Date
    let participants: [String]?
    var userContact: UserContact?

    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case admin
        case messagerieUUID
        case users
        case timestamp
        case participants
    }

    init(
        uid: String,
        title: String,
        admin: String,
        messagerieUUID: String,
        users: [String],
        timestamp: Date,
        participants: [String]? = nil,
        userContact: UserContact? = nil
    ) {
        self.uid = uid
        self.title = title
        self.admin = admin
        self.messagerieUUID = messagerieUUID
        self.users = users
        self.timestamp = timestamp
        self.participants = participants
        self.userContact = userContact
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        title = try values.decode(String.self, forKey: .title)
        admin = try values.decode(String.self, forKey: .admin)
        messagerieUUID = try values.decode(String.self, forKey: .messagerieUUID)
        users = try values.decode([String].self, forKey: .users)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        participants = try values.decodeIfPresent([String].self, forKey: .participants)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(admin, forKey: .admin)
        try container.encode(messagerieUUID, forKey: .messagerieUUID)
        try container.encode(users, forKey: .users)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(participants, forKey: .participants)
    }
    
    var printObject: String {
        return "@@@ ---------Conv---------- "
        + "\n @@@ uid : \(uid)"
        + "\n @@@ title : \(title)"
        + "\n @@@ admin : \(admin)"
        + "\n @@@ messagerieUUID : \(messagerieUUID)"
        + "\n @@@ users : \(users)"
        + "\n @@@ timestamp : \(timestamp)"
        + "\n @@@ participants : \(String(describing: participants))"
        + "\n @@@ ------------------"
    }
}
