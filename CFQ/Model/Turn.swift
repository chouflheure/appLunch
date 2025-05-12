
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

    init(uid: String, titleEvent: String, date: Date?, pictureURLString: String, admin: String, description: String, invited: [String], participants: [String], mood: [Int], messagerieUUID: String, placeTitle: String, placeAdresse: String, placeLatitude: Double, placeLongitude: Double) {
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
        lhs.placeLongitude == rhs.placeLongitude
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
        + "\n date : \(date)"
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
