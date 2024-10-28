//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Roman Tverdokhleb on 10.05.2024.
//

import UserNotifications

/// A service extension that allows customizing the content of push notifications before they are delivered to the user
class NotificationService: UNNotificationServiceExtension {
    
    /// A closure that processes the modified notification content and delivers it to the user
    var contentHandler: ((UNNotificationContent) -> Void)?
    /// A mutable copy of the notification content that can be modified before being shown to the user
    var bestAttemptContent: UNMutableNotificationContent?

    /// Called when a notification is received, allowing you to modify its content before it's presented to the user
    /// - Parameters:
    ///   - request: The notification request that triggered this extension
    ///   - contentHandler: A closure to call when the modified notification content is ready to be presented
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modifies the notification's title
            bestAttemptContent.title = bestAttemptContent.title
            
            // Fetches the localized message body based on the app's current language setting
            let language = appLanguage
            if let body = bestAttemptContent.userInfo[language] as? String {
                bestAttemptContent.body = body
            }
            
            // Passes the modified content back to the system
            contentHandler(bestAttemptContent)
        }
    }
    
    /// The method fetches the app's language from UserDefaults or returns a default language if the user has not set a preference
    /// - Returns: A string representing the current language code (e.g., "en" for English)
    private var appLanguage: String {
        if let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            if let currentLang = userDefault.string(forKey: Texts.LanguageSave.userDefaultsKey) {
                return currentLang
            }
        }
        // Fallback to the default language
        return Texts.NetworkRequest.language
    }
    
    /// Called when the service extension is about to expire. Ensures that the modified notification content is delivered before the time expires
    ///
    /// If the extension's time limit is reached before `didReceive(_:withContentHandler:)` finishes, this method ensures the best attempt at content modification is delivered to the user
    override func serviceExtensionTimeWillExpire() {
        // If time is about to expire, pass the best modified content back to the system
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
