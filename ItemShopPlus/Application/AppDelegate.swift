//
//  AppDelegate.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import Firebase
import FirebaseMessaging
import UserNotifications
import UIKit
import YandexMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, _ in
            guard success else { return }
            
            print("Success in APNS registry")
        }
        
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.NotificationSettings.key) {
            if retrievedString == Texts.NotificationSettings.enable {
                application.registerForRemoteNotifications()
            }
        } else {
            application.registerForRemoteNotifications()
        }
        
        MobileAds.initializeSDK(completionHandler: completionHandler)
        
        if let deviceLanguage = Bundle.main.preferredLocalizations.first,
           let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            userDefault.set(deviceLanguage, forKey: Texts.LanguageSave.userDefaultsKey)
        }

        return true
    }
    
    func completionHandler() {
        print("YandexMobileAds init completed")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard token != nil else { return }
            print("Token received successful")
        }
    }
}

