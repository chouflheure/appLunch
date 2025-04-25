
import SwiftUI


struct TestNotif: View {
    let notifService = NotifService()
    var body: some View {
        VStack {
            Button(action: {
                notifService.scheduleNotification()
            }) {
                Text("Send Notification")
            }
        }
    }
}

class NotifService {
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Titre de la Notification"

        // Définir les actions pour les boutons
        let firstAction = UNNotificationAction(identifier: "FIRST_BUTTON_IDENTIFIER",
                                               title: "💃 Ça sort !",
                                               options: [])

        let secondAction = UNNotificationAction(identifier: "SECOND_BUTTON_IDENTIFIER",
                                                title: "🥱 Ça dort ce soir",
                                                options: [])

        let firstAction1 = UNNotificationAction(identifier: "FIRST_BUTTON_IDENTIFIER1",
                                               title: "rep 1",
                                               options: [])

        let secondAction1 = UNNotificationAction(identifier: "SECOND_BUTTON_IDENTIFIER1",
                                                title: "rep 2",
                                                options: [])
        // Créer une catégorie pour les actions
        let category = UNNotificationCategory(identifier: "daily_ask_turn", actions: [firstAction, secondAction], intentIdentifiers: [], options: [])

        let category1 = UNNotificationCategory(identifier: "", actions: [firstAction1, secondAction1], intentIdentifiers: [], options: [])
        
        // Enregistrer la catégorie
        UNUserNotificationCenter.current().setNotificationCategories([category, category1])

        // Assigner la catégorie au contenu de la notification
        content.categoryIdentifier = "daily_ask_turn"

        // Définir le déclencheur pour la notification (par exemple, 5 secondes après l'appel)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)

        // Ajouter la notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur lors de l'ajout de la notification: \(error.localizedDescription)")
            }
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = "Ceci est une notification non cliquable."
        content.categoryIdentifier = "NO_ACTION"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "TestNotification", content: content, trigger: trigger)


        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


