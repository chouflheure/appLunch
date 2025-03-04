import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

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
        print("@@@ Received remote notification: \(userInfo)")
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            print("@@@ Received notification in foreground: \(userInfo)")

            completionHandler([[.banner, .sound]])
        }
        
        // Handle user interaction with the notification
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print("@@@ User interacted with notification: \(userInfo)")
            
            completionHandler()
        }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
            refreshFCMToken()
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
    
    // Subscribe to a topic for topic-based notifications
    func subscribeToTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            completion(error)
        }
    }
    
    // Unsubscribe from a topic
    func unsubscribeFromTopic(_ topic: String, completion: @escaping (Error?) -> Void) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            completion(error)
        }
    }
}
