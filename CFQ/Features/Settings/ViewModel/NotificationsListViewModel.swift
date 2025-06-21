import SwiftUI
import Combine

class NotificationsListViewModel: ObservableObject {
    var fcmMessing = FCMService.shared
    private let topics = FCMService.shared.getSubscribedTopics()

    @Published var isActiveStates: [String: Bool] = [:]

    init() {
        for topic in NotificationType.allCases.map({ $0.topic }) {
            isActiveStates[topic] = topics.contains(topic)
        }
    }

    func toggleSubscription(to topic: String) {
        if isActiveStates[topic] ?? true {
            unsubscribeTo(topic: topic)
        } else {
            subscribeTo(topic: topic)
        }
        isActiveStates[topic]?.toggle()
    }

    func subscribeTo(topic: String) {
        fcmMessing.subscribeToTopic(topic) { error in
            if let error = error {
                Logger.log("Erreur lors de l'abonnement au topic : \(topic) : \(error.localizedDescription)", level: .warning)
            } else {
                Logger.log("Abonné avec succès au topic : \(topic)", level: .success)
            }
        }
    }

    func unsubscribeTo(topic: String) {
        fcmMessing.unsubscribeFromTopic(topic) { error in
            if let error = error {
                Logger.log("Erreur lors du désabonnement au topic : \(topic) : \(error.localizedDescription)", level: .warning)
            } else {
                Logger.log("Désabonné avec succès au topic : \(topic)", level: .success)
            }
        }
    }
}
