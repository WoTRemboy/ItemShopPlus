//
//  SettingsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import Foundation

enum SettingType {
    case notifications
    case appearance
    case cache
    case language
    case currency
    case email
    
    static func typeDefinition(name: String) -> SettingType {
        switch name {
        case "Notifications":
            return .notifications
        case "Appearance":
            return .appearance
        case "Clear Cache":
            return .cache
        case "Language":
            return .language
        case "Currency":
            return .currency
        case "Email":
            return .email
        default:
            return .appearance
        }
    }
}
