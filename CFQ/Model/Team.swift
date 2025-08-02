import Foundation

class Team: ObservableObject, Encodable, Decodable, Hashable, Equatable {
    let uid: String
    let title: String
    let pictureUrlString: String
    let friends: [String]
    let admins: [String]
    let timestamp: Date
    let cfqs: [CFQ]?
    let turns: [Turn]?
    @Published var friendsContact: [UserContact]?
    @Published var adminsContact: [UserContact]?
    
    init(
        uid: String,
        title: String,
        pictureUrlString: String,
        friends: [String],
        admins: [String],
        timestamp: Date,
        cfqs: [CFQ]? = nil,
        turns: [Turn]? = nil,
        friendsContact: [UserContact]? = nil,
        adminsContact: [UserContact]? = nil
    ) {
        self.uid = uid
        self.title = title
        self.pictureUrlString = pictureUrlString
        self.friends = friends
        self.admins = admins
        self.timestamp = timestamp
        self.cfqs = cfqs
        self.turns = turns
        self.friendsContact = friendsContact
        self.adminsContact = adminsContact
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case pictureUrlString
        case friends
        case admins
        case timestamp
        case cfqs
        case turns
        case friendsContact
        case adminsContact
    }

    // ✅ IMPLÉMENTATION DE HASHABLE
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid) // Utilise l'uid comme identificateur unique
    }
    
    // ✅ IMPLÉMENTATION DE EQUATABLE
    static func == (lhs: Team, rhs: Team) -> Bool {
        return lhs.uid == rhs.uid // Deux UserContact sont égaux s'ils ont le même uid
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        title = try values.decode(String.self, forKey: .title)
        pictureUrlString = try values.decode(String.self, forKey: .pictureUrlString)
        friends = try values.decode([String].self, forKey: .friends)
        admins = try values.decode([String].self, forKey: .admins)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        cfqs = try values.decodeIfPresent([CFQ].self, forKey: .cfqs)
        turns = try values.decodeIfPresent([Turn].self, forKey: .turns)
        friendsContact = try values.decodeIfPresent([UserContact].self, forKey: .friendsContact)
        adminsContact = try values.decodeIfPresent([UserContact].self, forKey: .adminsContact)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(title, forKey: .title)
        try container.encode(pictureUrlString, forKey: .pictureUrlString)
        try container.encode(friends, forKey: .friends)
        try container.encode(admins, forKey: .admins)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(cfqs, forKey: .cfqs)
        try container.encodeIfPresent(turns, forKey: .turns)
        try container.encodeIfPresent(friendsContact, forKey: .friendsContact)
        try container.encodeIfPresent(adminsContact, forKey: .adminsContact)
    }
    
    /*
    func toTeamGlobal() -> TeamGlobal {
        return TeamGlobal(
            uid: self.uid,
            title: self.title,
            pictureUrlString: self.pictureUrlString,
            friends: [],
            admins: []
        )
    }
    */
    
    var printObject: String {
        return "@@@ ---------TEAM---------- "
        + "\n @@@ uid : \(uid)"
        + "\n @@@ title : \(title)"
        + "\n @@@ pictureUrlString : \(pictureUrlString)"
        + "\n @@@ friends : \(friends)"
        + "\n @@@ admins : \(admins)"
        + "\n ------------------"
    }

}

/*
class TeamGlobal: Codable, Hashable {
    var uid: String
    var title: String
    var pictureUrlString: String
    var friends: [UserContact]
    var admins: [UserContact]

    init(uid: String, title: String, pictureUrlString: String, friends: [UserContact], admins: [UserContact]) {
        self.uid = uid
        self.title = title
        self.pictureUrlString = pictureUrlString
        self.friends = friends
        self.admins = admins
    }
    
    // Conformité à Equatable
    static func == (lhs: TeamGlobal, rhs: TeamGlobal) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.title == rhs.title &&
               lhs.pictureUrlString == rhs.pictureUrlString &&
               lhs.friends == rhs.friends &&
               lhs.admins == rhs.admins
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(title)
        hasher.combine(pictureUrlString)
        hasher.combine(friends)
        hasher.combine(admins)
    }
    
    var printObject: String {
        return "@@@ ---------Message---------- "
        + "\n @@@ uid : \(uid)"
        + "\n @@@ title : \(title)"
        + "\n @@@ pictureUrlString : \(pictureUrlString)"
        + "\n @@@ friends : \(friends)"
        + "\n @@@ admins : \(admins)"
        + "\n ------------------"
    }
}


*/
