import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import os.log

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        requestNotificationPermission(application)

        return true
    }
    
    private func requestNotificationPermission(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: authOptions) { granted, error in
        if let error = error {
            print("@@@ Error requesting notification authorization: \(error.localizedDescription)")
        }
            print("@@@ Notification authorization granted: \(granted)")
        }
        application.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let token = fcmToken {
            print("@@@ token = \(token)")
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
    }

    func refreshFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("@@@ Error retrieving FCM token: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("@@@ Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("@@@ Notification reçue en arrière-plan : \(userInfo)")
        os_log("@@@ Notification received in background", log: OSLog.default, type: .info)

        TestNotif().scheduleNotification(body: "body")
        
        
        if let category = userInfo["aps"] as? [String: Any],
           let categoryIdentifier = category["category"] as? String,
           categoryIdentifier == "NO_ACTION" {
            print("Action spécifique pour NO_ACTION")
            // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
        }

        // Vérifiez si la notification distante contient des informations spécifiques
            if let aps = userInfo["aps"] as? [String: Any],
               let alert = aps["alert"] as? [String: Any],
               let body = alert["body"] as? String {

                // Planifiez une notification locale
                TestNotif().scheduleNotification(body: body)
            }
        
        if let category = userInfo["aps"] as? [String: Any],
           let categoryIdentifier = category["category"] as? String,
           categoryIdentifier == "NO_ACTION" {
            print("Action spécifique pour NO_ACTION")
            // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
        }

        let result: UIBackgroundFetchResult
        if Auth.auth().canHandleNotification(userInfo) {
            result = .noData
        } else {
            result = .newData
        }

        completionHandler(result)
    }
    
    
    
    // when your are on the app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("here")
            let userInfo = notification.request.content.userInfo

                // Déclencher une action spécifique si nécessaire
                if let category = userInfo["aps"] as? [String: Any],
                   let categoryIdentifier = category["category"] as? String,
                   categoryIdentifier == "NO_ACTION" {
                    print("Action spécifique pour NO_ACTION")
                    // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
                }
        
        if let notificationType = userInfo["notificationType"] as? String {
            if notificationType == "daily_reminder" {
                print("@@@ here")
                // Gérer la notification de rappel quotidien
            }
        }

        let options: UNNotificationPresentationOptions = [.sound, .banner]

        completionHandler(options)
    }
        
        // Handle user interaction with the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("@@@ User interacted with notification: \(userInfo)")
        
        let actionIdentifier = response.actionIdentifier
        switch actionIdentifier {
                case "FIRST_BUTTON_IDENTIFIER":
                    // Gérer l'action du premier bouton
                    print("First button tapped")
                case "SECOND_BUTTON_IDENTIFIER":
                    // Gérer l'action du second bouton
                    print("Second button tapped")
                default:
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                }
        
        
        print("@@@ response.notification.request.content.categoryIdentifier = \(response.notification.request.content.categoryIdentifier)")
        if response.notification.request.content.categoryIdentifier == "NO_ACTION" {
            print("@@@ here")
            return
        } else {
            completionHandler()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        refreshFCMToken()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}


@main
struct CFQApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}



import Foundation
import Firebase
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





struct TestNotif: View {
    var body: some View {
        VStack {
            Button(action: {
                scheduleNotification(body: "test kiki")
            }) {
                Text("Send Notification")
            }
        }
    }
    
    func scheduleNotification(body: String) {
        let content = UNMutableNotificationContent()
        content.title = "Titre de la Notification"
        content.body = body

        // Définir les actions pour les boutons
        let firstAction = UNNotificationAction(identifier: "FIRST_BUTTON_IDENTIFIER",
                                               title: "💃 Ça sort !!",
                                               options: [])

        let secondAction = UNNotificationAction(identifier: "SECOND_BUTTON_IDENTIFIER",
                                                title: "🥱 Ça dort ce soir",
                                                options: [])

        let firstAction1 = UNNotificationAction(identifier: "FIRST_BUTTON_IDENTIFIER",
                                               title: "1",
                                               options: [])

        let secondAction1 = UNNotificationAction(identifier: "SECOND_BUTTON_IDENTIFIER",
                                                title: "2",
                                                options: [])
        // Créer une catégorie pour les actions
        let category = UNNotificationCategory(identifier: "CUSTOM_CATEGORY", actions: [firstAction, secondAction], intentIdentifiers: [], options: [])

        let category1 = UNNotificationCategory(identifier: "", actions: [firstAction1, secondAction1], intentIdentifiers: [], options: [])
        // Enregistrer la catégorie
        UNUserNotificationCenter.current().setNotificationCategories([category, category1])

        // Assigner la catégorie au contenu de la notification
        content.categoryIdentifier = "CUSTOM_CATEGORY"

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


