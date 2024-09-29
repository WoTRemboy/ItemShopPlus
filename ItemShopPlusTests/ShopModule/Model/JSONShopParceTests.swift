//
//  JSONShopParceTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/29/24.
//

import XCTest
@testable import ItemShopPlus

final class JSONShopParceTests: XCTestCase {

    // Test valid JSON parsing for ShopItem
    func testValidShopItemParsing() {
        let json: [String: Any] = [
            "mainId": "123",
            "displayName": "Test Item",
            "displayDescription": "This is a test item.",
            "displayType": "Outfit",
            "displayAssets": [
                ["productTag": "Product.BR", "background": "br_image.png"],
                ["productTag": "Product.Juno", "background": "juno_image.png"],
                ["productTag": "Product.DelMar", "background": "delmar_image.png"]
            ],
            "price": [
                "finalPrice": 100,
                "regularPrice": 120
            ],
            "offerDates": [
                "in": "2024-01-01T00:00:00.000Z",
                "out": "2024-01-10T00:00:00.000Z"
            ],
            "section": ["name": "Featured"],
            "buyAllowed": true,
            "rarity": ["id": "rare"],
            "series": ["name": "Item Series"]
        ]

        let shopItem = ShopItem.sharingParse(sharingJSON: json)

        XCTAssertNotNil(shopItem)
        XCTAssertEqual(shopItem?.id, "123")
        XCTAssertEqual(shopItem?.name, "Test Item")
        XCTAssertEqual(shopItem?.description, "This is a test item.")
        XCTAssertEqual(shopItem?.type, "Outfit")
        XCTAssertEqual(shopItem?.images.count, 3)
        XCTAssertEqual(shopItem?.price, 100)
        XCTAssertEqual(shopItem?.regularPrice, 120)
        XCTAssertTrue(shopItem?.buyAllowed ?? false)
        XCTAssertEqual(shopItem?.rarity, .rare)
        XCTAssertEqual(shopItem?.section, "Featured")
    }

    // Test invalid JSON parsing that should return nil
    func testInvalidShopItemParsing() {
        let invalidJson: [String: Any] = [
            "mainId": "123",
            "displayName": "Test Item"
            // Missing other required fields
        ]

        let shopItem = ShopItem.sharingParse(sharingJSON: invalidJson)

        XCTAssertNil(shopItem)
    }

    // Test valid JSON parsing for GrantedItem
    func testValidGrantedItemParsing() {
        let json: [String: Any] = [
            "id": "001",
            "name": "Granted Item",
            "description": "This is a granted item.",
            "rarity": ["id": "epic"],
            "type": ["id": "backpack", "name": "Backpack"],
            "images": ["background": "item_image.png", "full_background": "item_share_image.png"]
        ]

        let grantedItem = GrantedItem.sharingParce(sharingJSON: json)

        XCTAssertNotNil(grantedItem)
        XCTAssertEqual(grantedItem?.id, "001")
        XCTAssertEqual(grantedItem?.name, "Granted Item")
        XCTAssertEqual(grantedItem?.description, "This is a granted item.")
        XCTAssertEqual(grantedItem?.typeID, "backpack")
        XCTAssertEqual(grantedItem?.type, Texts.ShopPage.backpack)
        XCTAssertEqual(grantedItem?.image, "item_image.png")
        XCTAssertEqual(grantedItem?.shareImage, "item_share_image.png")
        XCTAssertEqual(grantedItem?.rarity, .epic)
    }

    // Test invalid JSON parsing for GrantedItem
    func testInvalidGrantedItemParsing() {
        let invalidJson: [String: Any] = [
            "id": "001",
            "name": "Granted Item"
            // Missing other required fields
        ]

        let grantedItem = GrantedItem.sharingParce(sharingJSON: invalidJson)

        XCTAssertNil(grantedItem)
    }
}
