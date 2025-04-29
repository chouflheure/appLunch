
import Foundation

class Turn: Codable, Hashable {
    let uid: String
    let title: String
    let date: Date
    let pictureUrlString: String
    let friends: [String]

    init(uid: String, title: String, date: Date, pictureUrlString: String, friends: [String]) {
        self.uid = uid
        self.title = title
        self.date = date
        self.pictureUrlString = pictureUrlString
        self.friends = friends
    }
    
    // Conformité à Equatable
    static func == (lhs: Turn, rhs: Turn) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.title == rhs.title &&
               lhs.date == rhs.date &&
               lhs.pictureUrlString == rhs.pictureUrlString &&
               lhs.friends == rhs.friends
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(title)
        hasher.combine(date)
        hasher.combine(pictureUrlString)
        hasher.combine(friends)
    }
}
