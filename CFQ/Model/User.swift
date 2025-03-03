import Foundation
import Combine

class User: ObservableObject, Encodable, Decodable {
    var uid: String
    var name: String
    var firstName: String
    var pseudo: String
    var profilePictureUrl: String
    var location: Set<String>
    var birthDate: Date?
    @Published var isActive: Bool
    var favorite: [String]
    var friends: [String]
    var invitedCfqs: [String]
    var invitedTurns: [String]
    var notificationsChannelId: String
    var postedCfqs: [String]
    var postedTurns: [String]
    var teams: [String]
    var tokenFCM: String
    var unreadNotificationsCount: Int
    // requests
    // conversations

    init(
        uid: String = "",
        name: String = "",
        firstName: String = "",
        pseudo: String = "",
        profilePictureUrl: String = "",
        location: Set<String> = [""],
        birthDate: Date? = nil,
        isActive: Bool = true,
        favorite: [String] = [""] ,
        friends: [String] = [""],
        invitedCfqs: [String] = [""],
        invitedTurns: [String] = [""],
        notificationsChannelId: String = "",
        postedCfqs: [String] = [""],
        postedTurns: [String] = [""],
        teams: [String] = [""],
        tokenFCM: String = "",
        unreadNotificationsCount: Int = 0
    ) {
        self.uid = uid
        self.name = name
        self.firstName = firstName
        self.pseudo = pseudo
        self.profilePictureUrl = profilePictureUrl
        self.location = location
        self.birthDate = birthDate
        self.isActive = isActive
        self.favorite = favorite
        self.friends = friends
        self.invitedCfqs = invitedCfqs
        self.invitedTurns = invitedTurns
        self.notificationsChannelId = notificationsChannelId
        self.postedCfqs = postedCfqs
        self.postedTurns = postedTurns
        self.teams = teams
        self.tokenFCM = tokenFCM
        self.unreadNotificationsCount = unreadNotificationsCount
    }

    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case firstName
        case pseudo
        case profilePictureUrl
        case location
        case birthDate
        case isActive
        case favorite
        case friends
        case invitedCfqs
        case invitedTurns
        case notificationsChannelId
        case postedCfqs
        case postedTurns
        case teams
        case tokenFCM
        case unreadNotificationsCount
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        name = try values.decode(String.self, forKey: .name)
        firstName = try values.decode(String.self, forKey: .firstName)
        pseudo = try values.decode(String.self, forKey: .pseudo)
        profilePictureUrl = try values.decode(String.self, forKey: .profilePictureUrl)
        isActive = try values.decode(Bool.self, forKey: .isActive)
        location = try values.decode(Set<String>.self, forKey: .location)
        favorite = try values.decode([String].self, forKey: .favorite)
        friends = try values.decode([String].self, forKey: .friends)
        invitedCfqs = try values.decode([String].self, forKey: .invitedCfqs)
        invitedTurns = try values.decode([String].self, forKey: .invitedTurns)
        notificationsChannelId = try values.decode(String.self, forKey: .notificationsChannelId)
        postedCfqs = try values.decode([String].self, forKey: .postedCfqs)
        postedTurns = try values.decode([String].self, forKey: .postedTurns)
        teams = try values.decode([String].self, forKey: .teams)
        tokenFCM = try values.decode(String.self, forKey: .tokenFCM)
        unreadNotificationsCount = try values.decode(Int.self, forKey: .unreadNotificationsCount)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isActive, forKey: .isActive)
    }
}
