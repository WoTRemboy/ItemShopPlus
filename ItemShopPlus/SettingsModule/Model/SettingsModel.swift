//
//  SettingsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import Foundation
import UIKit

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


struct CurrencyModel {
    let type: Currency
    let name: String
    let code: String
    let symbol: String
    
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


struct AppTheme {
    let name: String
    let style: UIUserInterfaceStyle
    
    static let themes = [
        AppTheme(name: Texts.AppearanceSettings.system, style: .unspecified),
        AppTheme(name: Texts.AppearanceSettings.light, style: .light),
        AppTheme(name: Texts.AppearanceSettings.dark, style: .dark)
    ]
}
