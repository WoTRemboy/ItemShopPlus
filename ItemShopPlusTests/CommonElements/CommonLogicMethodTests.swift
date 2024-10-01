//
//  CommonLogicMethodTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class CommonLogicMethodsTests: XCTestCase {
    
    // MARK: - Tests for CapitalizeMethods
    
    // Test capitalizing words with underscores
    internal func testCapitalizeFirstLetterWithUnderscores() {
        let input = "test_string_with_underscores"
        let expectedOutput = "Test String With Underscores"
        
        let result = CommonLogicMethods.capitalizeFirstLetter(input: input)
        
        XCTAssertEqual(result, expectedOutput)
    }
    
    // Test capitalizing words with spaces
    internal func testCapitalizeFirstLetterWithSpaces() {
        let input = "test string with spaces"
        let expectedOutput = "Test String With Spaces"
        
        let result = CommonLogicMethods.capitalizeFirstLetter(input: input)
        
        XCTAssertEqual(result, expectedOutput)
    }

    // MARK: - Tests for SelectingMethods
    
    // Test selectBanner with valid bannerText
    internal func testSelectBannerWithValidText() {
        XCTAssertEqual(SelectingMethods.selectBanner(bannerText: "New"), .new)
        XCTAssertEqual(SelectingMethods.selectBanner(bannerText: "vbucksoff"), .sale)
    }
    
    // Test selectBanner with nil or unknown bannerText
    internal func testSelectBannerWithNilOrUnknownText() {
        XCTAssertEqual(SelectingMethods.selectBanner(bannerText: nil), .null)
        XCTAssertEqual(SelectingMethods.selectBanner(bannerText: "unknown"), .null)
    }
    
    // Test selectCurrency with valid code
    internal func testSelectCurrencyWithValidCode() {
        XCTAssertEqual(SelectingMethods.selectCurrency(code: Texts.Currency.Code.eur), .eur)
        XCTAssertEqual(SelectingMethods.selectCurrency(code: Texts.Currency.Code.usd), .usd)
    }
    
    // Test selectCurrency with nil or unknown code
    internal func testSelectCurrencyWithNilOrUnknownCode() {
        XCTAssertEqual(SelectingMethods.selectCurrency(code: nil), .usd)
        XCTAssertEqual(SelectingMethods.selectCurrency(code: "unknown"), .usd)
    }
    
    // Test selectCurrencyPosition for different currencies
    internal func testSelectCurrencyPosition() {
        XCTAssertEqual(SelectingMethods.selectCurrencyPosition(type: .usd), .left)
        XCTAssertEqual(SelectingMethods.selectCurrencyPosition(type: .rub), .right)
    }
    
    // Test selectRarity with valid rarityText
    internal func testSelectRarityWithValidText() {
        XCTAssertEqual(SelectingMethods.selectRarity(rarityText: "common"), .common)
        XCTAssertEqual(SelectingMethods.selectRarity(rarityText: "epic"), .epic)
    }
    
    // Test selectRarity with nil or unknown rarityText
    internal func testSelectRarityWithNilOrUnknownText() {
        XCTAssertEqual(SelectingMethods.selectRarity(rarityText: nil), .common)
        XCTAssertEqual(SelectingMethods.selectRarity(rarityText: "unknown"), .common)
    }
    
    // Test selectPayType with valid payType
    internal func testSelectPayTypeWithValidText() {
        XCTAssertEqual(SelectingMethods.selectPayType(payType: "free"), .free)
        XCTAssertEqual(SelectingMethods.selectPayType(payType: "paid"), .paid)
    }
    
    // Test selectPayType with unknown payType
    internal func testSelectPayTypeWithUnknownText() {
        XCTAssertEqual(SelectingMethods.selectPayType(payType: "unknown"), .paid)
    }
    
    // Test selectPartyType with valid type
    internal func testSelectPartyTypeWithValidType() {
        XCTAssertEqual(SelectingMethods.selectPartyType(type: "solo"), Texts.StatsDetailsPage.solo)
        XCTAssertEqual(SelectingMethods.selectPartyType(type: "duo"), Texts.StatsDetailsPage.duo)
    }
    
    // Test selectPartyType with unknown type
    internal func testSelectPartyTypeWithUnknownType() {
        XCTAssertEqual(SelectingMethods.selectPartyType(type: "unknown"), Texts.StatsDetailsPage.solo)
    }
    
    // Test selectWeaponTag with valid tag
    internal func testSelectWeaponTagWithValidTag() {
        XCTAssertEqual(SelectingMethods.selectWeaponTag(tag: "Pistols"), Texts.LootDetailsStats.pistols)
        XCTAssertEqual(SelectingMethods.selectWeaponTag(tag: "Assault"), Texts.LootDetailsStats.assault)
    }
    
    // Test selectWeaponTag with unknown tag
    internal func testSelectWeaponTagWithUnknownTag() {
        XCTAssertEqual(SelectingMethods.selectWeaponTag(tag: "unknown"), Texts.ShopPage.allMenu)
    }
}
