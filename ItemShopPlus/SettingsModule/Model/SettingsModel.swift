//
//  SettingsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import Foundation
import UIKit

// MARK: - SettingType

/// Enum representing the different types of settings in the app
enum SettingType {
    // Represents the notification settings option
    case notifications
    // Represents the appearance settings option (dark, light, or system themes)
    case appearance
    // Represents the cache management settings option
    case cache
    // Represents the language selection settings option
    case language
    // Represents the currency selection settings option
    case currency
    // Represents the designer information option
    case developer
    // /// Represents the designer information option
    case designer
    // Represents the email communication settings option
    case email
    
    /// Defines the type of setting based on the provided name
    /// - Parameter name: The name of the setting as a string
    /// - Returns: A `SettingType` corresponding to the name
    static func typeDefinition(name: String) -> SettingType {
        switch name {
        case Texts.SettingsPage.notificationsTitle:
            return .notifications
        case Texts.SettingsPage.appearanceTitle:
            return .appearance
        case Texts.SettingsPage.cacheTitle:
            return .cache
        case Texts.SettingsPage.languageTitle:
            return .language
        case Texts.SettingsPage.currencyTitle:
            return .currency
        case Texts.SettingsPage.developerTitle:
            return .developer
        case Texts.SettingsPage.designerTitle:
            return .designer
        case Texts.SettingsPage.emailTitle:
            return .email
        default:
            return .appearance
        }
    }
}

// MARK: - CurrencyModel

/// Struct representing a currency model with its type, name, code, and symbol
struct CurrencyModel {
    /// The type of currency (e.g., usd, eur, gbr)
    let type: Currency
    /// The name of the currency (e.g., "United States Dollar")
    let name: String
    /// The currency code (e.g., "USD", "EUR")
    let code: String
    /// The symbol representing the currency (e.g., "$", "€")
    let symbol: String
    
    /// A static array containing different available currencies
    static let currencies = [
        CurrencyModel(type: .aud, name: Texts.Currency.Name.aud, code: Texts.Currency.Code.aud, symbol: Texts.Currency.Symbol.aud),
        CurrencyModel(type: .brl, name: Texts.Currency.Name.brl, code: Texts.Currency.Code.brl, symbol: Texts.Currency.Symbol.brl),
        CurrencyModel(type: .cad, name: Texts.Currency.Name.cad, code: Texts.Currency.Code.cad, symbol: Texts.Currency.Symbol.cad),
        CurrencyModel(type: .dkk, name: Texts.Currency.Name.dkk, code: Texts.Currency.Code.dkk, symbol: Texts.Currency.Symbol.dkk),
        CurrencyModel(type: .eur, name: Texts.Currency.Name.eur, code: Texts.Currency.Code.eur, symbol: Texts.Currency.Symbol.eur),
        CurrencyModel(type: .gbp, name: Texts.Currency.Name.gbr, code: Texts.Currency.Code.gbp, symbol: Texts.Currency.Symbol.gbp),
        CurrencyModel(type: .jpy, name: Texts.Currency.Name.jpy, code: Texts.Currency.Code.jpy, symbol: Texts.Currency.Symbol.jpy),
        CurrencyModel(type: .nok, name: Texts.Currency.Name.nok, code: Texts.Currency.Code.nok, symbol: Texts.Currency.Symbol.nok),
        CurrencyModel(type: .rub, name: Texts.Currency.Name.rub, code: Texts.Currency.Code.rub, symbol: Texts.Currency.Symbol.rub),
        CurrencyModel(type: .sek, name: Texts.Currency.Name.sek, code: Texts.Currency.Code.sek, symbol: Texts.Currency.Symbol.sek),
        CurrencyModel(type: .lira, name: Texts.Currency.Name.lira, code: Texts.Currency.Code.lira, symbol: Texts.Currency.Symbol.lira),
        CurrencyModel(type: .usd, name: Texts.Currency.Name.usd, code: Texts.Currency.Code.usd, symbol: Texts.Currency.Symbol.usd)
    ]
}

// MARK: - AppTheme

/// Struct representing a theme configuration for the app
struct AppTheme {
    /// The key used to represent the theme in storage (e.g., "SystemValue")
    let keyValue: String
    /// The name of the theme (e.g., "System", "Light", "Dark")
    let name: String
    /// The interface style of the theme (`.light`, `.dark`, `.unspecified`)
    let style: UIUserInterfaceStyle
    
    /// A static array containing different themes available for the app
    static let themes = [
        AppTheme(keyValue: Texts.AppearanceSettings.systemValue, name: Texts.AppearanceSettings.system, style: .unspecified),
        AppTheme(keyValue: Texts.AppearanceSettings.lightValue, name: Texts.AppearanceSettings.light, style: .light),
        AppTheme(keyValue: Texts.AppearanceSettings.darkValue, name: Texts.AppearanceSettings.dark, style: .dark)
    ]
    
    /// Converts the theme key to a readable string
    /// - Parameter key: The key of the theme as a string
    /// - Returns: The corresponding theme name as a string
    static func keyToValue(key: String) -> String {
        switch key {
        case "SystemValue":
            return Texts.AppearanceSettings.system
        case "LightValue":
            return Texts.AppearanceSettings.light
        case "DarkValue":
            return Texts.AppearanceSettings.dark
        default:
            return Texts.AppearanceSettings.system
        }
    }
}
