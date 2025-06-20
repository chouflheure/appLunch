
import UserNotifications
import FirebaseMessaging

class FCMService {
    static let shared = FCMService()

    private let subscribedTopicsKey = "subscribedTopics"

    private init() {}

    // Get the current stored FCM token
    var currentToken: String? {
        return UserDefaults.standard.string(forKey: "fcmToken")
    }

    // Request a new token
    func refreshToken(completion: @escaping (String?, Error?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                completion(nil, error)
                return
            }

            if let token = token {
                UserDefaults.standard.set(token, forKey: "fcmToken")
            }

            completion(token, nil)
        }
    }

    func subscribeToTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            if let error = error {
                completion(error)
                return
            }

            self.addSubscribedTopic(topic)
            completion(nil)
        }
    }

    // Unsubscribe from a topic
    func unsubscribeFromTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            if let error = error {
                print("Échec du désabonnement au topic \(topic) : \(error.localizedDescription)")
                completion(error)
                return
            }

            self.removeSubscribedTopic(topic)
            print("Désabonnement avec succès au topic \(topic)")
            completion(nil)
        }
    }

    func subscribeToAllTopics() {
        let topics = NotificationType.allCases
        topics.forEach { subscribeToTopic($0.title) { _ in } }
    }

    // Get the list of subscribed topics
    func getSubscribedTopics() -> [String] {
        return UserDefaults.standard.stringArray(forKey: subscribedTopicsKey) ?? []
    }

    // Add a topic to the local list
    private func addSubscribedTopic(_ topic: String) {
        var topics = getSubscribedTopics()
        if !topics.contains(topic) {
            topics.append(topic)
            UserDefaults.standard.set(topics, forKey: subscribedTopicsKey)
        }
    }

    // Remove a topic from the local list
    private func removeSubscribedTopic(_ topic: String) {
        var topics = getSubscribedTopics()
        if let index = topics.firstIndex(of: topic) {
            topics.remove(at: index)
            UserDefaults.standard.set(topics, forKey: subscribedTopicsKey)
        }
    }
}
