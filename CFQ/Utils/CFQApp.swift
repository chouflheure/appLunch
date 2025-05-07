
import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import Firebase

//@main
class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private var firebaseService: FirebaseService?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        firebaseService = FirebaseService()
        Messaging.messaging().delegate = self
        requestNotificationPermission(application)
        registerNotificationCategories()
        return true
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
            identifier: "INVITE_CATEGORY",
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
                print("@@@ Error requesting notification authorization: \(error.localizedDescription)")
            }
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
        let notifService = NotifService()
        
        notifService.scheduleNotification()

        if let category = userInfo["aps"] as? [String: Any],
           let categoryIdentifier = category["category"] as? String,
           categoryIdentifier == "NO_ACTION" {
            // Exécuter une tâche en arrière-plan (ex: envoyer une requête réseau)
        }

        // Vérifiez si la notification distante contient des informations spécifiques
            if let aps = userInfo["aps"] as? [String: Any],
               let alert = aps["alert"] as? [String: Any],
               let body = alert["body"] as? String {

                // Planifiez une notification locale
                notifService.scheduleNotification()
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
                // print("@@@ here")
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
        print("@@@ User interacted with notification: \(response.notification.request.content.userInfo)")

        guard let userUID = UserDefaults.standard.string(forKey: "userUID"), let firebaseService = firebaseService else {
            return
        }
        print("@@@ USSSSSSER = \(userUID)")

        let actionIdentifier = response.actionIdentifier
        switch actionIdentifier {
            case "FIRST_BUTTON_IDENTIFIER":
            // Gérer l'action du premier bouton
                print("First button tapped")
            firebaseService.updateDataByID(data: ["isActive": true], to: .users, at: userUID)
            case "SECOND_BUTTON_IDENTIFIER":
                // Gérer l'action du second bouton
                print("Second button tapped")
            firebaseService.updateDataByID(data: ["isActive": false], to: .users, at: userUID)
        case "DECLINE_IDENTIFIER":
                print("User declined the invitation")
            case "ACCEPT_IDENTIFIER":
                print("User accepted the invitation")
        default:
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
        
        if response.notification.request.content.categoryIdentifier == "NO_ACTION" {
            // print("@@@ here")
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
    @State private var isActive = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

