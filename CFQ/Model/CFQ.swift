
import Foundation

class CFQ: Codable, Hashable {
    let uid: String
    let title: String
    let admin: String
    let messagerieUUID: String
    let users: [String]
    
    init(uid: String, title: String, admin: String, messagerieUUID: String, users: [String]) {
        self.uid = uid
        self.title = title
        self.admin = admin
        self.messagerieUUID = messagerieUUID
        self.users = users
    }
    
    static func == (lhs: CFQ, rhs: CFQ) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.title == rhs.title &&
               lhs.admin == rhs.admin &&
               lhs.messagerieUUID == rhs.messagerieUUID &&
               lhs.users == rhs.users
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(title)
        hasher.combine(admin)
        hasher.combine(messagerieUUID)
        hasher.combine(users)
    }
}
