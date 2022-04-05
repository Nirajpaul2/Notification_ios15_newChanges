//
//  AppDelegate.swift
//  NotificationP
//
//  Created by Purplle on 04/04/22.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerCustomActionCategories()
        registerForPushNotifications()
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// MARK: - Remote Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - Register
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // let token = deviceToken.map { (String(format: "%02.2hhx", $0)) }.joined()
        let token = deviceToken.map { data in String(format: "%02.2hhx", data) }.joined()
        print("🆔 \(#function) Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("📩 \(#function)")
    }
    
    // MARK: - Receive
    
    // Called when a notification is delivered to a foreground app.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("📩 \(#function)")
        // when app is open and in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
    // Called to let your app know which action was selected by the user for a given notification.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("\n📩 \(#function)")
        
        // 1. Get the Notification Identifier
        let identifier = response.notification.request.identifier
        print("🆔 \(#function) Id: \(identifier)")
        
        // 2. Check for Custom Actions to Handle
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier: print("Default Action identifier") // the user swiped to unlock
        case UNNotificationDismissActionIdentifier: print("Dismiss Action identifier") // the user dismissed the Notification
        case "like-action": print("like-action")
        case "comment-action": print("comment-action")
                
        default: print("Switch default")
        }
        
        
        // 3. Check for Custom data passed with Notification
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customDataKey"] as? String {
            print("Custom data received: \(customData)")
        }
        
        // you must call the completion handler when you're done
        completionHandler()
    }
    
    // MARK: - Customiszation
    
    func registerForPushNotifications() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        // let options: UNAuthorizationOptions = [.provisional]
        UNUserNotificationCenter.current().requestAuthorization(options: [options]) { granted, _ in
            print("✅ \(#function) Permission granted: \(granted)")
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerCustomActionCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self // Must call where UNUserNotificationCenterDelegate is
        
        let likeActionIcon = UNNotificationActionIcon(systemImageName: "hand.thumbsup")

        let likeAction = UNNotificationAction(identifier: "like-action", title: "Like", options: [], icon: likeActionIcon)

        let commentActionIcon = UNNotificationActionIcon(systemImageName: "text.bubble")

        let commentAction = UNTextInputNotificationAction(identifier: "comment-action", title: "Comment", options: [], icon: commentActionIcon, textInputButtonTitle: "Post", textInputPlaceholder: "Type here..")
        
        let category2 = UNNotificationCategory(identifier: "categoryIdentifier", actions: [likeAction, commentAction], intentIdentifiers: [])
        
        center.setNotificationCategories([category2])
    }
    
}


