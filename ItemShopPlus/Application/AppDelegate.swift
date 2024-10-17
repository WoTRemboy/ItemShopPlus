//
//  AppDelegate.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import Firebase
import FirebaseMessaging
import UserNotifications
import YandexMobileAds
import OSLog
import UIKit

/// A log object to organize messages
private let logger = Logger(subsystem: "Application", category: "AppDelegate")

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    // MARK: - Application Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set delegates for Messaging and UNUserNotificationCenter
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization for user notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, _ in
            guard success else {
                logger.error("Request authorization for user notifications failed")
                return
            }
            
            logger.info("Success in APNS registry")
        }
        
        // Check notification settings in UserDefaults
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.NotificationSettings.key) {
            if retrievedString == Texts.NotificationSettings.enable {
                // Register for remote notifications
                application.registerForRemoteNotifications()
            }
        } else {
            // Register for remote notifications by default
            application.registerForRemoteNotifications()
        }
        
        // Initialize Yandex Mobile Ads SDK
        MobileAds.initializeSDK(completionHandler: completionHandler)
        
        // Save the device language to UserDefaults
        if let deviceLanguage = Bundle.main.preferredLocalizations.first,
           let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            userDefault.set(deviceLanguage, forKey: Texts.LanguageSave.userDefaultsKey)
            logger.info("Device language successfully saved in UserDefaults")
        } else {
            logger.error("Device language could not be found from Bundle")
        }

        return true
    }
    
    // MARK: - Yandex Mobile Ads Initialization
    
    /// Completion handler for Yandex Mobile Ads SDK initialization
    func completionHandler() {
        logger.info("YandexMobileAds init completed")
    }
    
    // MARK: - Messaging Delegate Methods
    
    /// Called when a new FCM registration token is received
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard token != nil else {
                logger.error("FCM registration token not received")
                return
            }
            logger.info("FCM registration token received successful")
        }
    }
}

