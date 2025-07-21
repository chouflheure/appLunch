import Foundation
import Combine

class User: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var name: String
    @Published var firstName: String?
    @Published var pseudo: String
    @Published var profilePictureUrl: String
    @Published var location: String
    @Published var birthDate: Date?
    @Published var isActive: Bool
    @Published var phoneNumber: String?
    @Published var favorite: [String]?
    @Published var friends: [String]
    @Published var invitedCfqs: [String]?
    @Published var invitedTurns: [String]?
    @Published var notificationsChannelId: String?
    @Published var postedCfqs: [String]?
    @Published var postedTurns: [String]?
    @Published var teams: [String]?
    @Published var tokenFCM: String
    @Published var unreadNotificationsCount: Int
    @Published var isPrivateAccount: Bool
    @Published var requestsFriends: [String]
    @Published var messagesChannelId: [String]
    @Published var sentFriendRequests: [String]
    @Published var userFriendsContact: [UserContact]?
    @Published var someNotificationUnread: Bool?
    @Published var arrayConversationUnread: [String]?
    // conversations

    init(
        uid: String = "",
        name: String = "",
        firstName: String? = nil,
        pseudo: String = "",
        profilePictureUrl: String = "",
        location: String = "",
        birthDate: Date = Date(),
        isActive: Bool = true,
        phoneNumber: String = "",
        favorite: [String] = [] ,
        friends: [String] = [],
        invitedCfqs: [String] = [],
        invitedTurns: [String] = [],
        notificationsChannelId: String = "",
        postedCfqs: [String] = [],
        postedTurns: [String] = [],
        teams: [String] = [],
        tokenFCM: String = "",
        unreadNotificationsCount: Int = 0,
        isPrivateAccount: Bool = true,
        requestsFriends: [String] = [],
        messagesChannelId: [String] = [],
        sentFriendRequests: [String] = [],
        userFriendsContact: [UserContact]? = nil,
        someNotificationUnread: Bool? = false,
        arrayConversationUnread: [String]? = []
    ) {
        self.uid = uid
        self.name = name
        self.firstName = firstName
        self.pseudo = pseudo
        self.profilePictureUrl = profilePictureUrl
        self.location = location
        self.birthDate = birthDate
        self.isActive = isActive
        self.phoneNumber = phoneNumber
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
        self.isPrivateAccount = isPrivateAccount
        self.requestsFriends = requestsFriends
        self.messagesChannelId = messagesChannelId
        self.sentFriendRequests = sentFriendRequests
        self.userFriendsContact = userFriendsContact
        self.someNotificationUnread = someNotificationUnread
        self.arrayConversationUnread = arrayConversationUnread
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
        case phoneNumber
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
        case isPrivateAccount
        case requestsFriends
        case messagesChannelId
        case sentFriendRequests
        case userFriendsContact
        case someNotificationUnread
        case arrayConversationUnread
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        name = try values.decode(String.self, forKey: .name)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        pseudo = try values.decode(String.self, forKey: .pseudo)
        profilePictureUrl = try values.decode(String.self, forKey: .profilePictureUrl)
        isActive = try values.decode(Bool.self, forKey: .isActive)
        location = try values.decode(String.self, forKey: .location)
        birthDate = try values.decode(Date.self, forKey: .birthDate)
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
        isPrivateAccount = try values.decode(Bool.self, forKey: .isPrivateAccount)
        requestsFriends = try values.decode([String].self, forKey: .requestsFriends)
        messagesChannelId = try values.decode([String].self, forKey: .messagesChannelId)
        sentFriendRequests = try values.decode([String].self, forKey: .sentFriendRequests)
        userFriendsContact = try values.decodeIfPresent([UserContact].self, forKey: .userFriendsContact)
        someNotificationUnread = try values.decodeIfPresent(Bool.self, forKey: .someNotificationUnread)
        arrayConversationUnread = try values.decodeIfPresent([String].self, forKey: .arrayConversationUnread)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encode(pseudo, forKey: .pseudo)
        try container.encode(profilePictureUrl, forKey: .profilePictureUrl)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(location, forKey: .location)
        try container.encode(birthDate, forKey: .birthDate)
        try container.encode(favorite, forKey: .favorite)
        try container.encode(friends, forKey: .friends)
        try container.encode(invitedCfqs, forKey: .invitedCfqs)
        try container.encode(invitedTurns, forKey: .invitedTurns)
        try container.encode(notificationsChannelId, forKey: .notificationsChannelId)
        try container.encode(postedCfqs, forKey: .postedCfqs)
        try container.encode(postedTurns, forKey: .postedTurns)
        try container.encode(teams, forKey: .teams)
        try container.encode(tokenFCM, forKey: .tokenFCM)
        try container.encode(unreadNotificationsCount, forKey: .unreadNotificationsCount)
        try container.encode(isPrivateAccount, forKey: .isPrivateAccount)
        try container.encode(requestsFriends, forKey: .requestsFriends)
        try container.encode(messagesChannelId, forKey: .messagesChannelId)
        try container.encode(sentFriendRequests, forKey: .sentFriendRequests)
        try container.encodeIfPresent(userFriendsContact, forKey: .userFriendsContact)
        try container.encodeIfPresent(someNotificationUnread, forKey: .someNotificationUnread)
        try container.encodeIfPresent(arrayConversationUnread, forKey: .arrayConversationUnread)
    }

    var guestMode: User {
       return User(
        uid: "Guest",
        name: "Guest",
        firstName: "Guest",
        pseudo: "Guest",
        profilePictureUrl: "",
        location: "Ta loc",
        birthDate: Date(),
        isActive: true,
        favorite: [""] ,
        friends: [""],
        invitedCfqs: [""],
        invitedTurns: [""],
        notificationsChannelId: "",
        postedCfqs: [""],
        postedTurns: [""],
        teams: [""],
        tokenFCM: "",
        unreadNotificationsCount: 0,
        isPrivateAccount: true,
        requestsFriends: [""],
        messagesChannelId: [],
        sentFriendRequests: [],
        userFriendsContact: []
       )
    }
    // TODO: - For debug
    var printObject: String {
        return "@@@ uid : \(uid) | name : \(name) | firstName : \(String(describing: firstName)) | pseudo : \(pseudo) | profilePictureUrl : \(profilePictureUrl) | location : \(location) | location : \(String(describing: birthDate))"
    }
}
