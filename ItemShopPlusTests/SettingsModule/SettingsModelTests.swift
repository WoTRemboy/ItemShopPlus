//
//  SettingsModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class SettingsModelTests: XCTestCase {

    // Test for SettingType.typeDefinition(name:) function
    internal func testTypeDefinition() {
        // Test known cases
        XCTAssertEqual(SettingType.typeDefinition(name: "Notifications"), .notifications)
        XCTAssertEqual(SettingType.typeDefinition(name: "Appearance"), .appearance)
        XCTAssertEqual(SettingType.typeDefinition(name: "Clear Cache"), .cache)
        XCTAssertEqual(SettingType.typeDefinition(name: "Language"), .language)
        XCTAssertEqual(SettingType.typeDefinition(name: "Currency"), .currency)
        XCTAssertEqual(SettingType.typeDefinition(name: "Developer"), .developer)
        XCTAssertEqual(SettingType.typeDefinition(name: "Designer"), .designer)
        XCTAssertEqual(SettingType.typeDefinition(name: "Email"), .email)

        // Test unknown case (default case)
        XCTAssertEqual(SettingType.typeDefinition(name: "Unknown"), .appearance)
    }
    
    // Test for CurrencyModel initialization
    internal func testCurrencyModelInitialization() {
        let audCurrency = CurrencyModel(type: .aud, name: "Australian Dollar", code: "AUD", symbol: "$")

        XCTAssertEqual(audCurrency.type, .aud)
        XCTAssertEqual(audCurrency.name, "Australian Dollar")
        XCTAssertEqual(audCurrency.code, "AUD")
        XCTAssertEqual(audCurrency.symbol, "$")
    }

    // Test if currencies array contains all predefined currencies
    internal func testCurrenciesArray() {
        let currencies = CurrencyModel.currencies

        XCTAssertEqual(currencies.count, 12, "There should be 12 predefined currencies in the array")
        
        // Check for the first currency in the array
        XCTAssertEqual(currencies.first?.type, .aud)
        XCTAssertEqual(currencies.first?.name, Texts.Currency.Name.aud)
        XCTAssertEqual(currencies.first?.code, Texts.Currency.Code.aud)
        XCTAssertEqual(currencies.first?.symbol, Texts.Currency.Symbol.aud)
    }

    // Test for AppTheme initialization
    internal func testAppThemeInitialization() {
        let systemTheme = AppTheme(keyValue: "SystemValue", name: "System", style: .unspecified)

        XCTAssertEqual(systemTheme.keyValue, "SystemValue")
        XCTAssertEqual(systemTheme.name, "System")
        XCTAssertEqual(systemTheme.style, .unspecified)
    }

    // Test if themes array contains all predefined themes
    internal func testThemesArray() {
        let themes = AppTheme.themes

        XCTAssertEqual(themes.count, 3, "There should be 3 predefined themes in the array")

        // Check for the first theme in the array
        XCTAssertEqual(themes.first?.keyValue, Texts.AppearanceSettings.systemValue)
        XCTAssertEqual(themes.first?.name, Texts.AppearanceSettings.system)
        XCTAssertEqual(themes.first?.style, .unspecified)
    }

    // Test for AppTheme.keyToValue(key:) function
    internal func testKeyToValue() {
        XCTAssertEqual(AppTheme.keyToValue(key: "SystemValue"), Texts.AppearanceSettings.system)
        XCTAssertEqual(AppTheme.keyToValue(key: "LightValue"), Texts.AppearanceSettings.light)
        XCTAssertEqual(AppTheme.keyToValue(key: "DarkValue"), Texts.AppearanceSettings.dark)

        // Test for an unknown key (should return system as default)
        XCTAssertEqual(AppTheme.keyToValue(key: "UnknownKey"), Texts.AppearanceSettings.system)
    }
}
