import Foundation

class User: Encodable, Decodable, ObservableObject {
    var uid: String
    var name: String
    var firstName: String
    var username: String
    var profilePictureUrl: String
    var location: Set<String>
    var birthDate: Date?
    var isActive: Bool
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
        username: String = "",
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
        self.username = username
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
}
