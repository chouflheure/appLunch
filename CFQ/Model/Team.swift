
class Team: Codable, Hashable {
    let uid: String
    let title: String
    let pictureUrlString: String
    let friends: [String]
    let admins: [String]

    init(uid: String, title: String, pictureUrlString: String, friends: [String], admins: [String]) {
        self.uid = uid
        self.title = title
        self.pictureUrlString = pictureUrlString
        self.friends = friends
        self.admins = admins
    }
    
    // Conformité à Equatable
    static func == (lhs: Team, rhs: Team) -> Bool {
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
    
    func toTeamGlobal() -> TeamGlobal {
        return TeamGlobal(
            uid: self.uid,
            title: self.title,
            pictureUrlString: self.pictureUrlString,
            friends: [],
            admins: []
        )
    }
}


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
}


