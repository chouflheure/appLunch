
class MessageCellModel: Codable, Hashable {
    var uid: String
    var titleConversation: String
    var messagePreview: String
    var time: String
    var hasUnReadMessage: Bool
    
    init(uid: String, titleConversation: String, messagePreview: String, time: String, hasUnReadMessage: Bool) {
        self.uid = uid
        self.titleConversation = titleConversation
        self.messagePreview = messagePreview
        self.time = time
        self.hasUnReadMessage = hasUnReadMessage
    }
    
    static func == (lhs: MessageCellModel, rhs: MessageCellModel) -> Bool {
        return lhs.uid == rhs.uid &&
               lhs.titleConversation == rhs.titleConversation &&
               lhs.messagePreview == rhs.messagePreview &&
               lhs.time == rhs.time &&
               lhs.hasUnReadMessage == rhs.hasUnReadMessage
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
        hasher.combine(titleConversation)
        hasher.combine(messagePreview)
        hasher.combine(time)
        hasher.combine(hasUnReadMessage)
    }
}
