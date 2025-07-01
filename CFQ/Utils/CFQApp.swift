import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseMessaging
import SwiftUI
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    private var firebaseService: FirebaseService?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil ) -> Bool
    {
        FirebaseApp.configure()
        firebaseService = FirebaseService()
        setupNotificationActions()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        requestNotificationPermission(application)
        
        return true
    }

    private func setUpNotificationHandling() {
        let subscribedTopicsKey = "subscribedTopics"
        NotificationType.allCases.forEach { topic in
            UserDefaults.standard.set(topic.topic, forKey: subscribedTopicsKey)
            Messaging.messaging().subscribe(toTopic: topic.topic) { error in
                if let error = error {
                    print("@@@ error subscribe topic: \(error)")
                } else {
                    print("@@@ good subscribe topic: \(topic)")
                }
            }
        }
    }

    
    func setupNotificationActions() {
        // Action "Oui, je sors"
        let yesAction = UNNotificationAction(
            identifier: "YES_ACTION",
            title: "🎉 Oui, je sors !",
            options: [] // Ouvre l'app
        )
        
        // Action "Non, je reste"
        let noAction = UNNotificationAction(
            identifier: "NO_ACTION",
            title: "🏠 Non, je reste",
            options: [] // Reste en arrière-plan
        )
        
        // Créer la catégorie avec les actions
        let category = UNNotificationCategory(
            identifier: "DAILY_ASK_CATEGORY",
            actions: [yesAction, noAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Enregistrer la catégorie
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    // Gérer les actions de notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let actionIdentifier = response.actionIdentifier
        let userInfo = response.notification.request.content.userInfo
        
        switch actionIdentifier {
        case "YES_ACTION":
            handleYesResponse(userInfo: userInfo)
            
        case "NO_ACTION":
            handleNoResponse(userInfo: userInfo)
            
        default:
            // Action par défaut (tap sur la notification)
            handleDefaultTap(userInfo: userInfo)
        }
        
        completionHandler()
    }
    
    func handleYesResponse(userInfo: [AnyHashable: Any]) {
            print("Utilisateur a répondu: OUI")
            // Mettre à jour Firestore
            updateUserStatus(isActive: true, response: "yes")
        }
        
        func handleNoResponse(userInfo: [AnyHashable: Any]) {
            print("Utilisateur a répondu: NON")
            // Mettre à jour Firestore
            updateUserStatus(isActive: false, response: "no")
        }
        
        func handleDefaultTap(userInfo: [AnyHashable: Any]) {
            print("@@@ Tap normal sur la notification")
            // Ouvrir l'app normalement
        }
    
    func updateUserStatus(isActive: Bool, response: String) {
        guard let userUID = UserDefaults.standard.string(forKey: "userUID"),
            let firebaseService = firebaseService
        else {
            return
        }
        
            // guard let userId = Auth.auth().currentUser?.uid else { return }
            
        firebaseService.updateDataByID(data: ["isActive": isActive], to: .users, at: userUID)
        
        /*
            let db = Firestore.firestore()
            db.collection("users").document(userId).updateData([
                "isActive": isActive,
                "lastResponse": response,
                "responseTimestamp": FieldValue.serverTimestamp()
            ]) { error in
                if let error = error {
                    print("Erreur mise à jour: \(error)")
                } else {
                    print("Statut mis à jour avec succès")
                }
            }
         */
        }
    
    func registerNotificationCategories() {
        let acceptAction = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: [.foreground]
        )

        let declineAction = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: [.destructive]
        )

        let inviteCategory = UNNotificationCategory(
            identifier: "daily_ask_turn",
            actions: [declineAction, acceptAction],
            intentIdentifiers: [],
            options: []
        )

        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([inviteCategory])
    }

    private func requestNotificationPermission(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]

        center.requestAuthorization(options: authOptions) { granted, error in
            if let error = error {
                print(
                    "@@@ Error requesting notification authorization: \(error.localizedDescription)"
                )
            }
        }
        application.registerForRemoteNotifications()
    }

    func messaging(
        _ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?
    ) {
        if let token = fcmToken {
            print("@@@ token = \(token)")
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
    }

    func refreshFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print(
                    "@@@ Error retrieving FCM token: \(error.localizedDescription)"
                )
                return
            }
        }
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("@@@ FAILED to register for remote notifications: \(error.localizedDescription)")
        print("@@@ Error details: \(error)")
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (
            UIBackgroundFetchResult
        ) -> Void
    ) {
        let notifService = NotifService()

        notifService.scheduleNotification()

        if let category = userInfo["aps"] as? [String: Any],
            let categoryIdentifier = category["category"] as? String,
            categoryIdentifier == "NO_ACTION"
        {
            // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
        }

        // Vérifiez si la notification distante contient des informations spécifiques
        if let aps = userInfo["aps"] as? [String: Any],
            let alert = aps["alert"] as? [String: Any],
            let body = alert["body"] as? String
        {

            // Planifiez une notification locale
            notifService.scheduleNotification()
        }

        if let category = userInfo["aps"] as? [String: Any],
            let categoryIdentifier = category["category"] as? String,
            categoryIdentifier == "NO_ACTION"
        {
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
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (
            UNNotificationPresentationOptions
        ) -> Void
    ) {

        let userInfo = notification.request.content.userInfo

        // Déclencher une action spécifique si nécessaire
        if let category = userInfo["aps"] as? [String: Any],
            let categoryIdentifier = category["category"] as? String,
            categoryIdentifier == "NO_ACTION"
        {
            print("Action spécifique pour NO_ACTION")
            // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
        }

        if let notificationType = userInfo["notificationType"] as? String {
            if notificationType == "daily_reminder" {
                // print("@@@ here")
                // Gérer la notification de rappel quotidien
            }
        }

        let options: UNNotificationPresentationOptions = [.sound, .banner]

        completionHandler(options)
    }

    /*
    // Handle user interaction with the notification
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        print("@@@ User interacted with notification: \(userInfo)")
        print(
            "@@@ User interacted with notification: \(response.notification.request.content.userInfo)"
        )

        guard let userUID = UserDefaults.standard.string(forKey: "userUID"),
            let firebaseService = firebaseService
        else {
            return
        }
        print("@@@ USSSSSSER = \(userUID)")

        let actionIdentifier = response.actionIdentifier
        switch actionIdentifier {
        case "FIRST_BUTTON_IDENTIFIER":
            // Gérer l'action du premier bouton
            print("First button tapped")
            firebaseService.updateDataByID(
                data: ["isActive": true], to: .users, at: userUID)
        case "SECOND_BUTTON_IDENTIFIER":
            // Gérer l'action du second bouton
            print("Second button tapped")
            firebaseService.updateDataByID(
                data: ["isActive": false], to: .users, at: userUID)
        case "DECLINE_IDENTIFIER":
            print("User declined the invitation")
        case "ACCEPT_IDENTIFIER":
            print("User accepted the invitation")
        default:
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }

        if response.notification.request.content.categoryIdentifier
            == "NO_ACTION"
        {
            // print("@@@ here")
            return
        } else {
            completionHandler()
        }
    }
*/
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        refreshFCMToken()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func application(
        _ app: UIApplication, open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        return false
    }
}

@main
struct CFQApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}




// TEST A FAIRE :
// https://claude.ai/chat/34109bc7-8c8f-432c-89df-a73be3a7f4ff
/*
 import UserNotifications
 import FirebaseMessaging

 // MARK: - AppDelegate ou SceneDelegate
 extension AppDelegate: UNUserNotificationCenterDelegate {
     
     // Cette méthode est appelée quand l'app reçoit une notification en arrière-plan
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                               willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         
         let userInfo = notification.request.content.userInfo
         
         // Récupérer l'ID de l'expéditeur depuis les données de la notification
         if let senderUID = userInfo["senderUID"] as? String {
             
             // Récupérer l'UID de l'utilisateur actuel
             let currentUserUID = Auth.auth().currentUser?.uid ?? ""
             
             // Si l'expéditeur est l'utilisateur actuel, ne pas afficher la notification
             if senderUID == currentUserUID {
                 print("🚫 Notification ignorée - envoyée par l'utilisateur actuel")
                 completionHandler([]) // Pas d'affichage
                 return
             }
         }
         
         // Afficher la notification normalement
         print("✅ Notification affichée")
         completionHandler([.banner, .sound, .badge])
     }
     
     // Cette méthode est appelée quand l'utilisateur tape sur la notification
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                               didReceive response: UNNotificationResponse,
                               withCompletionHandler completionHandler: @escaping () -> Void) {
         
         let userInfo = response.notification.request.content.userInfo
         
         // Gérer la navigation vers la conversation
         if let conversationId = userInfo["conversationId"] as? String {
             // Naviguer vers la conversation
             navigateToConversation(conversationId: conversationId)
         }
         
         completionHandler()
     }
 }

 // MARK: - Messaging Delegate
 extension AppDelegate: MessagingDelegate {
     
     // Cette méthode est appelée quand l'app reçoit un message de données
     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
         print("📱 Message de données reçu:", remoteMessage.appData)
         
         // Récupérer les données
         let messageData = remoteMessage.appData
         
         // Vérifier si c'est l'utilisateur actuel qui a envoyé le message
         if let senderUID = messageData["senderUID"] as? String {
             let currentUserUID = Auth.auth().currentUser?.uid ?? ""
             
             if senderUID == currentUserUID {
                 print("🚫 Message ignoré - envoyé par l'utilisateur actuel")
                 return
             }
         }
         
         // Traiter le message normalement
         handleIncomingMessage(messageData)
     }
 }

 // MARK: - Fonctions utilitaires
 extension AppDelegate {
     
     private func navigateToConversation(conversationId: String) {
         // Implémenter la navigation vers la conversation
         print("🔄 Navigation vers la conversation: \(conversationId)")
         
         // Exemple avec un coordinator pattern
         DispatchQueue.main.async {
             // Votre logique de navigation
             NotificationCenter.default.post(
                 name: NSNotification.Name("NavigateToConversation"),
                 object: nil,
                 userInfo: ["conversationId": conversationId]
             )
         }
     }
     
     private func handleIncomingMessage(_ messageData: [AnyHashable: Any]) {
         // Traiter les messages de données (mise à jour UI, etc.)
         if let conversationId = messageData["conversationId"] as? String,
            let type = messageData["type"] as? String {
             
             switch type {
             case "new_message":
                 // Mettre à jour l'UI des messages
                 updateMessagesUI(for: conversationId)
             default:
                 break
             }
         }
     }
     
     private func updateMessagesUI(for conversationId: String) {
         DispatchQueue.main.async {
             // Notifier les vues concernées
             NotificationCenter.default.post(
                 name: NSNotification.Name("NewMessageReceived"),
                 object: nil,
                 userInfo: ["conversationId": conversationId]
             )
         }
     }
 }

 // MARK: - Configuration dans AppDelegate
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
     // Configuration Firebase
     FirebaseApp.configure()
     
     // Configuration des notifications
     UNUserNotificationCenter.current().delegate = self
     Messaging.messaging().delegate = self
     
     // Demander l'autorisation pour les notifications
     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
         if granted {
             print("✅ Autorisation notifications accordée")
             DispatchQueue.main.async {
                 application.registerForRemoteNotifications()
             }
         } else {
             print("❌ Autorisation notifications refusée")
         }
     }
     
     return true
 }

 // MARK: - Gestion des topics
 class NotificationManager {
     
     static let shared = NotificationManager()
     
     func subscribeToNewMessages() {
         Messaging.messaging().subscribe(toTopic: "new_message") { error in
             if let error = error {
                 print("❌ Erreur abonnement topic: \(error)")
             } else {
                 print("✅ Abonné au topic 'new_message'")
             }
         }
     }
     
     func unsubscribeFromNewMessages() {
         Messaging.messaging().unsubscribe(fromTopic: "new_message") { error in
             if let error = error {
                 print("❌ Erreur désabonnement topic: \(error)")
             } else {
                 print("✅ Désabonné du topic 'new_message'")
             }
         }
     }
 }
 */
