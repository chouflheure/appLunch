import Foundation
import Combine

class User: ObservableObject, Encodable, Decodable {
   @Published var uid: String
   @Published var name: String
   @Published var firstName: String
   @Published var pseudo: String
   @Published var profilePictureUrl: String
   @Published var location: Set<String>
   @Published var birthDate: Date?
   @Published var isActive: Bool
   @Published var favorite: [String]
   @Published var friends: [String]
   @Published var invitedCfqs: [String]
   @Published var invitedTurns: [String]
   @Published var notificationsChannelId: String
   @Published var postedCfqs: [String]
   @Published var postedTurns: [String]
   @Published var teams: [String]
   @Published var tokenFCM: String
   @Published var unreadNotificationsCount: Int
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
