
class Notification: Encodable, Decodable {
    let uid: String

    init(uid: String) {
        self.uid = uid
    }
}
