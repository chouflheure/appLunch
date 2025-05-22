
import Foundation
import SwiftUI

class Conversation: ObservableObject, Encodable, Decodable {
    @Published var uid: String
    @Published var titleConv: String
    @Published var pictureEventURL: String
    @Published var messagesArrayUID: [String] = []
    @Published var typeEvent: String
    @Published var eventUID: String
    @Published var lastMessageSender: String
    @Published var lastMessageDate: Date?
    @Published var lastMessage: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case titleConv
        case pictureEventURL
        case messagesArrayUID
        case typeEvent
        case eventUID
        case lastMessageSender
        case lastMessageDate
        case lastMessage
    }

    init(
        uid: String,
        titleConv: String,
        pictureEventURL: String,
        messagesArrayUID: [String],
        typeEvent: String,
        eventUID: String,
        lastMessageSender: String,
        lastMessageDate: Date,
        lastMessage: String
    ) {
        self.uid = uid
        self.titleConv = titleConv
        self.pictureEventURL = pictureEventURL
        self.messagesArrayUID = messagesArrayUID
        self.typeEvent = typeEvent
        self.eventUID = eventUID
        self.lastMessageSender = lastMessageSender
        self.lastMessageDate = lastMessageDate
        self.lastMessage = lastMessage
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uid = try values.decode(String.self, forKey: .uid)
        titleConv = try values.decode(String.self, forKey: .titleConv)
        pictureEventURL = try values.decode(String.self, forKey: .pictureEventURL)
        messagesArrayUID = try values.decode([String].self, forKey: .messagesArrayUID)
        typeEvent = try values.decode(String.self, forKey: .typeEvent)
        eventUID = try values.decode(String.self, forKey: .eventUID)
        lastMessageSender = try values.decode(String.self, forKey: .lastMessageSender)
        lastMessageDate = try values.decodeIfPresent(Date.self, forKey: .lastMessageDate)
        lastMessage = try values.decode(String.self, forKey: .lastMessage)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(titleConv, forKey: .titleConv)
        try container.encode(pictureEventURL, forKey: .pictureEventURL)
        try container.encode(messagesArrayUID, forKey: .messagesArrayUID)
        try container.encode(typeEvent, forKey: .typeEvent)
        try container.encode(eventUID, forKey: .eventUID)
        try container.encode(lastMessageSender, forKey: .lastMessageSender)
        try container.encodeIfPresent(lastMessageDate, forKey: .lastMessageDate)
        try container.encode(lastMessage, forKey: .lastMessage)
    }
    
    var printObject: String {
        return "@@@ ---------Conv---------- "
        + "@@@ \nuid : \(uid)"
        + "@@@ \n titleEvent : \(titleConv)"
        + "@@@ \n messagesArrayUID : \(messagesArrayUID)"
        + "@@@ \n eventUID : \(eventUID)"
        + "@@@ \n typeEvent : \(typeEvent)"
        + "@@@ \n eventUID : \(eventUID)"
        + "@@@ \n lastMessageSender : \(lastMessageSender)"
        + "@@@ \n lastMessageDate : \(lastMessageDate)"
        + "@@@ \n lastMessage : \(lastMessage)"
        + "@@@ \n ------------------"
    }
}
