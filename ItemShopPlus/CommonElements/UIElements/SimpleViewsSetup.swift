//
//  SimpleViewsSetup.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

internal func alertControllerSetup(title: String?, message: String, parent: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default)
    alertController.addAction(okAction)
    parent.present(alertController, animated: true)
}
