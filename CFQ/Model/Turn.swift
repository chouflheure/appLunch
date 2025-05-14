/*
import Foundation

class Turn: Codable, Hashable, Identifiable {
    var uid: String
    var titleEvent: String
    var date: Date?
    var pictureURLString: String
    var admin: String
    var description: String
    var invited: [String]
    var participants: [String]
    var mood: [Int]
    var messagerieUUID: String
    var placeTitle: String
    var placeAdresse: String
    var placeLatitude: Double
    var placeLongitude: Double
    var adminContact: UserContact?

    init(uid: String, titleEvent: String, date: Date?, pictureURLString: String, admin: String, description: String, invited: [String], participants: [String], mood: [Int], messagerieUUID: String, placeTitle: String, placeAdresse: String, placeLatitude: Double, placeLongitude: Double, adminRef: User) {
        self.uid = uid
        self.titleEvent = titleEvent
        self.date = date
        self.pictureURLString = pictureURLString
        self.admin = admin
        self.description = description
        self.invited = invited
        self.participants = participants
        self.mood = mood
        self.messagerieUUID = messagerieUUID
        self.placeTitle = placeTitle
        self.placeAdresse = placeAdresse
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.adminRef = adminRef
    }
    
    // Conformité à Equatable
    static func == (lhs: Turn, rhs: Turn) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.titleEvent == rhs.titleEvent &&
        lhs.date == rhs.date &&
        lhs.pictureURLString == rhs.pictureURLString &&
        lhs.admin == rhs.admin &&
        lhs.description == rhs.description &&
        lhs.invited == rhs.invited &&
        lhs.participants == rhs.participants &&
        lhs.mood == rhs.mood &&
        lhs.messagerieUUID == rhs.messagerieUUID &&
        lhs.placeTitle == rhs.placeTitle &&
        lhs.placeAdresse == rhs.placeAdresse &&
        lhs.placeLatitude == rhs.placeLatitude &&
        lhs.placeLongitude == rhs.placeLongitude &&
        lhs.adminRef == rhs.adminRef
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(titleEvent)
        hasher.combine(date)
        hasher.combine(pictureURLString)
        hasher.combine(admin)
        hasher.combine(description)
        hasher.combine(invited)
        hasher.combine(participants)
        hasher.combine(mood)
        hasher.combine(messagerieUUID)
        hasher.combine(placeTitle)
        hasher.combine(placeAdresse)
        hasher.combine(placeLatitude)
        hasher.combine(placeLongitude)
    }
    
    var printObject: String {
        return "@@@ ---------TURN--------- "
        + "\nuid : \(uid)"
        + "\n titleEvent : \(titleEvent)"
        + "\n date : \(String(describing: date))"
        + "\n pictureUrlString : \(pictureURLString)"
        + "\n admin : \(admin)"
        + "\n description : \(description)"
        + "\n invited : \(invited)"
        + "\n participants : \(participants)"
        + "\n mood : \(mood)"
        + "\n placeTitle : \(placeTitle)"
        + "\n placeAdresse : \(placeAdresse)"
        + "\n placeLatitude : \(placeLatitude)"
        + "\n placeLongitude : \(placeLongitude)"
        + "\n ------------------"
    }
}

*/

import Foundation
import SwiftUI

class Turn: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var titleEvent: String
    @Published var date: Date?
    @Published var pictureURLString: String
    @Published var admin: String
    @Published var description: String
    @Published var invited: [String]
    @Published var participants: [String]
    @Published var mood: [Int]
    @Published var messagerieUUID: String
    @Published var placeTitle: String
    @Published var placeAdresse: String
    @Published var placeLatitude: Double
    @Published var placeLongitude: Double
    @Published var imageEvent: UIImage?
    @Published var adminContact: UserContact?
    // @Published var adminRef: User
    

    enum CodingKeys: String, CodingKey {
        case uid
        case titleEvent
        case date
        case pictureURLString
        case admin
        case description
        case invited
        case participants
        case mood
        case messagerieUUID
        case placeTitle
        case placeAdresse
        case placeLatitude
        case placeLongitude
        
        // case adminRef
        
    }

    init(
        uid: String,
        titleEvent: String,
        date: Date?,
        pictureURLString: String,
        admin: String,
        description: String,
        invited: [String],
        participants: [String],
        mood: [Int],
        messagerieUUID: String,
        placeTitle: String,
        placeAdresse: String,
        placeLatitude: Double,
        placeLongitude: Double
        
        // adminRef: User
    ) {
        self.uid = uid
        self.titleEvent = titleEvent
        self.date = date
        self.pictureURLString = pictureURLString
        self.admin = admin
        self.description = description
        self.invited = invited
        self.participants = participants
        self.mood = mood
        self.messagerieUUID = messagerieUUID
        self.placeTitle = placeTitle
        self.placeAdresse = placeAdresse
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        
        // self.adminRef = adminRef
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        titleEvent = try values.decode(String.self, forKey: .titleEvent)
        date = try values.decodeIfPresent(Date.self, forKey: .date)
        pictureURLString = try values.decode(String.self, forKey: .pictureURLString)
        admin = try values.decode(String.self, forKey: .admin)
        description = try values.decode(String.self, forKey: .description)
        invited = try values.decode([String].self, forKey: .invited)
        participants = try values.decode([String].self, forKey: .participants)
        mood = try values.decode([Int].self, forKey: .mood)
        messagerieUUID = try values.decode(String.self, forKey: .messagerieUUID)
        placeTitle = try values.decode(String.self, forKey: .placeTitle)
        placeAdresse = try values.decode(String.self, forKey: .placeAdresse)
        placeLatitude = try values.decode(Double.self, forKey: .placeLatitude)
        placeLongitude = try values.decode(Double.self, forKey: .placeLongitude)
        
        // adminRef = try values.decode(User.self, forKey: .adminRef)
        
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(titleEvent, forKey: .titleEvent)
        try container.encodeIfPresent(date, forKey: .date)
        try container.encode(pictureURLString, forKey: .pictureURLString)
        try container.encode(admin, forKey: .admin)
        try container.encode(description, forKey: .description)
        try container.encode(invited, forKey: .invited)
        try container.encode(participants, forKey: .participants)
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
        + "\n date : \(String(describing: date))"
        + "\n pictureUrlString : \(pictureURLString)"
        + "\n admin : \(admin)"
        + "\n description : \(description)"
        + "\n invited : \(invited)"
        + "\n participants : \(participants)"
        + "\n mood : \(mood)"
        + "\n placeTitle : \(placeTitle)"
        + "\n placeAdresse : \(placeAdresse)"
        + "\n placeLatitude : \(placeLatitude)"
        + "\n placeLongitude : \(placeLongitude)"
        // + "\n adminContact : \(adminRef.uid)"
        // + "\n adminContact : \(adminRef.name)"
        // + "\n adminContact : \(adminRef.pseudo)"
        + "\n ------------------"
    }
}



class TurnPreview: ObservableObject, Encodable {
    @Published var uid: String
    @Published var titleEvent: String
    @Published var date: Date?
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
        case date
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
        date: Date?,
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
        self.date = date
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
        try container.encodeIfPresent(date, forKey: .date)
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
        + "\n date : \(String(describing: date))"
        + "\n admin : \(admin)"
        + "\n description : \(description)"
        + "\n invited : \(invited)"
        + "\n mood : \(mood)"
        + "\n placeTitle : \(placeTitle)"
        + "\n placeAdresse : \(placeAdresse)"
        + "\n placeLatitude : \(placeLatitude)"
        + "\n placeLongitude : \(placeLongitude)"
        // + "\n adminContact : \(adminRef.uid)"
        // + "\n adminContact : \(adminRef.name)"
        // + "\n adminContact : \(adminRef.pseudo)"
        + "\n ------------------"
    }
}
