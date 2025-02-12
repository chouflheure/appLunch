
import Foundation

struct User: Codable {
    let name: String
    let lastName: String
    let pseudo: String
    let friends: [String]
    
    let localisation: [String]
    let birthDate: Date
    let tokenFCM: String
    let isActive: Bool
    let lastActiveTimestamp: Date
    let profilePictureUrl: String
    let searchKey: String
}
