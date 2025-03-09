
class Team: Encodable, Decodable {
    let uid: String
    let title: String
    let pictureUrlStirng: String
    let friends: [String]
    let cfqs: [String]
    let turns: [String]
    
    init(uid: String, title: String, pictureUrlStirng: String, friends: [String], cfqs: [String], turns: [String]) {
        self.uid = uid
        self.title = title
        self.pictureUrlStirng = pictureUrlStirng
        self.friends = friends
        self.cfqs = cfqs
        self.turns = turns
    }
}
