//
//  PushNotificationManager.swift
//  Appointments
//
//  Created by Aalim Mulji on 5/10/19.
//  Copyright © 2019 Aalim Mulji. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    //let userID: String
//    init(userID: String) {
//        self.userID = userID
//        super.init()
//    }
//    init() {
//        super.init()
//    }
    let gcmMessageIDKey = "gcm.message_id"
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let userType = UserDefaults.standard.value(forKey: "userType") as? String {
            
            if userType == "Student" {
                
                if let username = UserDefaults.standard.value(forKey: "username") as? String {
                    if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
                        let db = Firestore.firestore()
                        let usersRef = db.collection("students").whereField("username", isEqualTo: username)
                        
                        usersRef.getDocuments {(querySnapshot, error) in
                            guard let snapshot = querySnapshot else {
                                print("Error fetching snapshot result: \(error)")
                                return
                            }
                            for doc in snapshot.documents {
                                let docRef = doc.reference
                                docRef.setData(["fcmToken": token], merge: true)
                            }

                        }
                        
                    }
                }
            } else {
                if let profId = UserDefaults.standard.value(forKey: "profId") as? String {
                    if let token = UserDefaults.standard.value(forKey: "fcmToken") as? String {
                        let db = Firestore.firestore()
                        let usersRef = db.collection("Professors").whereField("profId", isEqualTo: profId)
                        usersRef.getDocuments { (querySnapshot, error) in
                            guard let snapshot = querySnapshot else {
                                print("Error fetching snapshot result: \(error)")
                                return
                            }
                            for doc in snapshot.documents {
                                let docRef = doc.reference
                                docRef.setData(["fcmToken": token], merge: true)
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        updateFirestorePushTokenIfNeeded()
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message Date: ", remoteMessage.appData)
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}
