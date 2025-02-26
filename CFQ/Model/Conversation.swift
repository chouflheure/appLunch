
class Conversation: Encodable, Decodable {
    let uid: String

    init(uid: String) {
        self.uid = uid
    }
}
