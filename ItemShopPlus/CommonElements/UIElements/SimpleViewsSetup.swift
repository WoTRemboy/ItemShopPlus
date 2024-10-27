//
//  SimpleViewsSetup.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

/// A class providing simple view setup methods for common UI components
final class SimpleViewsSetup {
    
    /// Displays an alert controller with a given title, message, and an "OK" action
    /// - Parameters:
    ///   - title: The title of the alert (optional)
    ///   - message: The message or body of the alert
    ///   - parent: The parent view controller that presents the alert
    static func alertControllerSetup(title: String?, message: String, parent: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default)
        alertController.addAction(okAction)
        parent.present(alertController, animated: true)
    }
}


