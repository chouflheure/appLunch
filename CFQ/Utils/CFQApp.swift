import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
                
                // Request permission for notifications and register for remote notifications
        requestNotificationPermission(application)
    return true
  }
    
    
    private func requestNotificationPermission(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 and above
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            center.requestAuthorization(options: authOptions) { granted, error in
                if let error = error {
                    print("@@@ Error requesting notification authorization: \(error.localizedDescription)")
                }
                print("@@@ Notification authorization granted: \(granted)")
            }
        } else {
            // For iOS 9 and below (rarely needed now)
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // This is needed to receive notifications
        application.registerForRemoteNotifications()
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("@@@ FCM token received: \(fcmToken ?? "nil")")
            
            if let token = fcmToken {
                // Store the token locally
                UserDefaults.standard.set(token, forKey: "fcmToken")
                
                // Create a data dictionary to pass the token via notification
                let dataDict: [String: String] = ["token": token]
                
                // Post a notification with the token that other parts of the app can observe
                
                // Send the token to your server
                sendFCMTokenToServer(token)
            }
        }
    func refreshFCMToken() {
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("@@@ Error retrieving FCM token: \(error.localizedDescription)")
                    return
                }
                
                if let token = token {
                    print("@@@ FCM token refreshed: \(token)")
                    self.sendFCMTokenToServer(token)
                }
            }
        }
    
    private func sendFCMTokenToServer(_ token: String) {
            // IMPLEMENTATION NEEDED: Replace with your actual API call
            // Example:
            // let url = URL(string: "https://your-api.com/register-device")!
            // var request = URLRequest(url: url)
            // request.httpMethod = "POST"
            // request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //
            // let body: [String: Any] = [
            //     "token": token,
            //     "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
            //     "platform": "ios"
            // ]
            //
            // request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            //
            // URLSession.shared.dataTask(with: request) { data, response, error in
            //     if let error = error {
            //         print("Error sending token to server: \(error.localizedDescription)")
            //         return
            //     }
            //     print("Token successfully sent to server")
            // }.resume()
            
            print("@@@ Token ready to send to server: \(token)")
        }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
        Messaging.messaging().apnsToken = deviceToken
                
        // For debugging - convert token to string format
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("@@@ APNS device token: \(token)")
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
            
            // Show the notification banner even when app is in foreground
            if #available(iOS 14.0, *) {
                completionHandler([[.banner, .sound]])
            } else {
                completionHandler([[.alert, .sound]])
            }
        }
        
        // Handle user interaction with the notification
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print("@@@ User interacted with notification: \(userInfo)")
            
            // Handle navigation based on notification content here
            
            completionHandler()
        }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
            // Refresh FCM token when app becomes active
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
