
import Foundation

class NotificationViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    @Published var notifications = [Notification]()

    init(user: User) {
        getNotifications(notificationUID: user.notificationsChannelId ?? user.uid)
    }
}

extension NotificationViewModel {
    func getNotifications(notificationUID: String) {
        
        firebaseService.getNotificationsByIds(notificationUID: notificationUID) { [weak self] (result: Result<[Notification], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let notifications):
                DispatchQueue.main.async {
                    self.notifications = notifications

                    // Fetch user contact pour chaque message
                    for (index, notification) in notifications.enumerated() {
                        self.fetchUserContactNotification(
                            at: index,
                            adminID: notification.uidUserNotif
                        )
                        // print("@@@ notifications = \(notifications.printObject)")
                    }
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error = \(error)")
            }
        }
    }
    
    private func fetchUserContactNotification(at index: Int, adminID: String) {
        firebaseService.getDataByID(from: .users, with: adminID) { [weak self] (result: Result<UserContact, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userMessage):
                // Assurez-vous que l'index est toujours valide
                guard index < self.notifications.count else { return }
                
                // Important: Sur le thread principal pour les UI updates
                DispatchQueue.main.async {
                    // Créez une copie du tableau entier pour déclencher le changement observable
                    let updatedMessageUser = self.notifications
                    updatedMessageUser[index].userContact = userMessage
                    // print("@@@ userMessage = \(userMessage)")
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    self.notifications = updatedMessageUser
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
