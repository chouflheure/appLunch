
import Foundation
import SwiftUI

class Turn: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var titleEvent: String
    @Published var dateStartEvent: Date?
    @Published var dateEndEvent: Date?
    @Published var pictureURLString: String
    @Published var admin: String
    @Published var description: String
    @Published var invited: [String]
    @Published var participants: [String]
    @Published var denied: [String]
    @Published var mayBeParticipate: [String]
    @Published var mood: [Int]
    @Published var messagerieUUID: String
    @Published var placeTitle: String
    @Published var placeAdresse: String
    @Published var placeLatitude: Double
    @Published var placeLongitude: Double
    @Published var timestamp: Date
    @Published var imageEvent: UIImage?
    @Published var adminContact: UserContact?
    @Published var link: String?
    @Published var linkTitle: String?
    var userUID: String?
    // @Published var userStatusParticipate: TypeParticipateButton = .none

    var userStatusParticipate: TypeParticipateButton {
        get {
            guard let currentUserId = userUID else {
                return .none
            }
            
            if participants.contains(currentUserId) {
                return .yes
            } else if mayBeParticipate.contains(currentUserId) {
                return .maybe
            } else if denied.contains(currentUserId) {
                return .no
            } else {
                return .none
            }
        }
        set {
            guard let currentUserId = userUID else {
                print("⚠️ Impossible de modifier le statut: userUID est nil")
                return
            }
            
            // Retirer l'utilisateur de tous les arrays d'abord
            removeUserFromAllArrays(userId: currentUserId)
            
            // Ajouter dans le bon array selon la nouvelle valeur
            switch newValue {
            case .yes:
                participants.append(currentUserId)
            case .maybe:
                mayBeParticipate.append(currentUserId)
            case .no:
                denied.append(currentUserId)
            case .none:
                // Ne rien faire, l'utilisateur est déjà retiré de tous les arrays
                break
            }
            
            // ✅ IMPORTANT: Déclencher une mise à jour UI
            objectWillChange.send()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case titleEvent
        case dateStartEvent
        case dateEndEvent
        case pictureURLString
        case admin
        case description
        case invited
        case participants
        case denied
        case mayBeParticipate
        case mood
        case messagerieUUID
        case placeTitle
        case placeAdresse
        case placeLatitude
        case placeLongitude
        case timestamp
        case link
        case linkTitle
        // case userStatusParticipate
    }

    init(
        uid: String,
        titleEvent: String,
        dateStartEvent: Date?,
        dateEndEvent: Date? = nil,
        pictureURLString: String,
        admin: String,
        description: String,
        invited: [String],
        participants: [String],
        denied: [String],
        mayBeParticipate: [String],
        mood: [Int],
        messagerieUUID: String,
        placeTitle: String,
        placeAdresse: String,
        placeLatitude: Double,
        placeLongitude: Double,
        timestamp: Date,
        link: String? = nil,
        lintiTitle: String? = nil,
        userUID: String? = nil
        // userStatusParticipate: TypeParticipateButton = .none
    ) {
        self.uid = uid
        self.titleEvent = titleEvent
        self.dateStartEvent = dateStartEvent
        self.dateEndEvent = dateEndEvent
        self.pictureURLString = pictureURLString
        self.admin = admin
        self.description = description
        self.invited = invited
        self.participants = participants
        self.denied = denied
        self.mayBeParticipate = mayBeParticipate
        self.mood = mood
        self.messagerieUUID = messagerieUUID
        self.placeTitle = placeTitle
        self.placeAdresse = placeAdresse
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.timestamp = timestamp
        self.link = link
        self.linkTitle = lintiTitle
        self.userUID = userUID
        // self.userStatusParticipate = userStatusParticipate
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        titleEvent = try values.decode(String.self, forKey: .titleEvent)
        dateStartEvent = try values.decodeIfPresent(Date.self, forKey: .dateStartEvent)
        dateEndEvent = try values.decodeIfPresent(Date.self, forKey: .dateEndEvent)
        pictureURLString = try values.decode(String.self, forKey: .pictureURLString)
        admin = try values.decode(String.self, forKey: .admin)
        description = try values.decode(String.self, forKey: .description)
        invited = try values.decode([String].self, forKey: .invited)
        participants = try values.decode([String].self, forKey: .participants)
        denied = try values.decode([String].self, forKey: .denied)
        mayBeParticipate = try values.decode([String].self, forKey: .mayBeParticipate)
        mood = try values.decode([Int].self, forKey: .mood)
        messagerieUUID = try values.decode(String.self, forKey: .messagerieUUID)
        placeTitle = try values.decode(String.self, forKey: .placeTitle)
        placeAdresse = try values.decode(String.self, forKey: .placeAdresse)
        placeLatitude = try values.decode(Double.self, forKey: .placeLatitude)
        placeLongitude = try values.decode(Double.self, forKey: .placeLongitude)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        linkTitle = try values.decodeIfPresent(String.self, forKey: .linkTitle)
        link = try values.decodeIfPresent(String.self, forKey: .link)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(titleEvent, forKey: .titleEvent)
        try container.encodeIfPresent(dateStartEvent, forKey: .dateStartEvent)
        try container.encodeIfPresent(dateEndEvent, forKey: .dateEndEvent)
        try container.encode(pictureURLString, forKey: .pictureURLString)
        try container.encode(admin, forKey: .admin)
        try container.encode(description, forKey: .description)
        try container.encode(invited, forKey: .invited)
        try container.encode(participants, forKey: .participants)
        try container.encode(denied, forKey: .denied)
        try container.encode(mayBeParticipate, forKey: .mayBeParticipate)
        try container.encode(mood, forKey: .mood)
        try container.encode(messagerieUUID, forKey: .messagerieUUID)
        try container.encode(placeTitle, forKey: .placeTitle)
        try container.encode(placeAdresse, forKey: .placeAdresse)
        try container.encode(placeLatitude, forKey: .placeLatitude)
        try container.encode(placeLongitude, forKey: .placeLongitude)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(linkTitle, forKey: .linkTitle)
        try container.encodeIfPresent(link, forKey: .link)
    }
    
    var printObject: String {
        return "@@@ ---------TURN--------- "
        + "\nuid : \(uid)"
        + "\n titleEvent : \(titleEvent)"
        + "\n pictureUrlString : \(pictureURLString)"
        + "\n admin : \(admin)"
        + "\n description : \(description)"
        + "\n invited : \(invited)"
        + "\n participants : \(participants)"
        + "\n denied : \(denied)"
        + "\n mayBeParticipate : \(mayBeParticipate)"
        + "\n mood : \(mood)"
        + "\n placeTitle : \(placeTitle)"
        + "\n placeAdresse : \(placeAdresse)"
        + "\n placeLatitude : \(placeLatitude)"
        + "\n placeLongitude : \(placeLongitude)"
        + "\n link : \(String(describing: link))"
        + "\n linkTitle : \(String(describing: linkTitle))"
        // + "\n adminContact : \(adminRef.uid)"
        // + "\n adminContact : \(adminRef.name)"
        // + "\n adminContact : \(adminRef.pseudo)"
        + "\n ------------------"
    }
    
    private func removeUserFromAllArrays(userId: String) {
        participants.removeAll { $0 == userId }
        mayBeParticipate.removeAll { $0 == userId }
        denied.removeAll { $0 == userId }
    }
}


class TurnPreview: ObservableObject, Encodable {
    @Published var uid: String
    @Published var titleEvent: String
    @Published var dateStartEvent: Date?
    @Published var dateEndEvent: Date?
    @Published var admin: String
    @Published var description: String
    @Published var invited: [String]
    @Published var mood: [Int]
    @Published var messagerieUUID: String
    @Published var placeTitle: String
    @Published var placeAdresse: String
    @Published var placeLatitude: Double
    @Published var placeLongitude: Double
    @Published var imageEvent: UIImage?
    // @Published var adminRef: User
    

    enum CodingKeys: String, CodingKey {
        case uid
        case titleEvent
        case dateStartEvent
        case dateEndEvent
        case admin
        case description
        case invited
        case mood
        case messagerieUUID
        case placeTitle
        case placeAdresse
        case placeLatitude
        case placeLongitude
        case imageEvent
        // case adminRef
        
    }

    init(
        uid: String,
        titleEvent: String,
        dateStartEvent: Date?,
        dateEndEvent: Date? = nil,
        admin: String,
        description: String,
        invited: [String],
        mood: [Int],
        messagerieUUID: String,
        placeTitle: String,
        placeAdresse: String,
        placeLatitude: Double,
        placeLongitude: Double,
        imageEvent: UIImage?
        // adminRef: User
    ) {
        self.uid = uid
        self.titleEvent = titleEvent
        self.dateStartEvent = dateStartEvent
        self.dateEndEvent = dateEndEvent
        self.admin = admin
        self.description = description
        self.invited = invited
        self.mood = mood
        self.messagerieUUID = messagerieUUID
        self.placeTitle = placeTitle
        self.placeAdresse = placeAdresse
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.imageEvent = imageEvent
        // self.adminRef = adminRef
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(titleEvent, forKey: .titleEvent)
        try container.encodeIfPresent(dateStartEvent, forKey: .dateStartEvent)
        try container.encodeIfPresent(dateEndEvent, forKey: .dateEndEvent)
        try container.encode(admin, forKey: .admin)
        try container.encode(description, forKey: .description)
        try container.encode(invited, forKey: .invited)
        try container.encode(mood, forKey: .mood)
        try container.encode(messagerieUUID, forKey: .messagerieUUID)
        try container.encode(placeTitle, forKey: .placeTitle)
        try container.encode(placeAdresse, forKey: .placeAdresse)
        try container.encode(placeLatitude, forKey: .placeLatitude)
        try container.encode(placeLongitude, forKey: .placeLongitude)
        // try container.encode(adminRef, forKey: .adminRef)
        
    }
    
    var printObject: String {
        return "@@@ ---------TURN--------- "
        + "\nuid : \(uid)"
        + "\n titleEvent : \(titleEvent)"
        + "\n dateStartEvent : \(String(describing: dateStartEvent))"
        + "\n dateEndEvent : \(String(describing: dateEndEvent))"
        + "\n admin : \(admin)"
        + "\n description : \(description)"
        + "\n invited : \(invited)"
        + "\n mood : \(mood)"
        + "\n placeTitle : \(placeTitle)"
        + "\n placeAdresse : \(placeAdresse)"
        + "\n placeLatitude : \(placeLatitude)"
        + "\n placeLongitude : \(placeLongitude)"
        + "\n ------------------"
    }
}
