//
//  JSONDetailLootParseTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class JSONDetailLootParseTests: XCTestCase {
    
    /// Test parsing a valid LootDetailsItem JSON structure
    internal func testLootDetailsItemParsingValid() {
        // Arrange: create a valid JSON dictionary
        let json: [String: Any] = [
            "id": "WID_ValidItem",
            "enabled": true,
            "name": "Test Weapon",
            "description": "A powerful weapon",
            "rarity": "rare",
            "type": "sword",
            "images": [
                "icon": "icon.png",
                "background": "background.png"
            ],
            "mainStats": [
                "DmgPB": 75.0,
                "FiringRate": 1.2,
                "ClipSize": Int(25),
                "ReloadTime": 2.5,
                "BulletsPerCartridge": 30,
                "Spread": 0.2,
                "SpreadDownsights": 0.1,
                "DamageZone_Critical": 1.8
            ],
            "searchTags": "weapon sword powerful"
        ]
        
        // Act: parse the JSON using the sharingParse method
        let parsedItem = LootDetailsItem.sharingParse(sharingJSON: json)
        
        // Assert: check if the parsed item has correct values
        XCTAssertNotNil(parsedItem, "Parsing should succeed for valid JSON")
        XCTAssertEqual(parsedItem?.id, "WID_ValidItem")
        XCTAssertEqual(parsedItem?.enabled, true)
        XCTAssertEqual(parsedItem?.name, "Test Weapon")
        XCTAssertEqual(parsedItem?.description, "A powerful weapon")
        XCTAssertEqual(parsedItem?.rarity, .rare)
        XCTAssertEqual(parsedItem?.type, .sword)
        XCTAssertEqual(parsedItem?.mainImage, "icon.png")
        XCTAssertEqual(parsedItem?.rarityImage, "background.png")
        XCTAssertEqual(parsedItem?.searchTags, ["weapon", "sword", "powerful"])
    }

    /// Test parsing an invalid LootDetailsItem JSON with missing fields
    internal func testLootDetailsItemParsingInvalid() {
        // Arrange: create an invalid JSON dictionary with missing fields
        let json: [String: Any] = [
            "id": "WID_InvalidItem",
            "enabled": true,
            "name": "Invalid Weapon",
            // Missing "rarity" and other essential fields
        ]
        
        // Act: try parsing the JSON
        let parsedItem = LootDetailsItem.sharingParse(sharingJSON: json)
        
        // Assert: ensure parsing fails
        XCTAssertNil(parsedItem, "Parsing should fail for invalid JSON with missing fields")
    }

    /// Test parsing a LootDetailsItem JSON that should be excluded based on ID filtering
    internal func testLootDetailsItemParsingExcludedID() {
        // Arrange: create a JSON with an ID that is in the exclusion list
        let json: [String: Any] = [
            "id": "WID_WaffleTruck_Assault_BigMoney",
            "enabled": true,
            "name": "Excluded Weapon",
            "rarity": "legendary",
            "type": "standart",
            "images": [
                "icon": "icon.png",
                "background": "background.png"
            ],
            "mainStats": [
                "DmgPB": 100.0,
                "FiringRate": 2.0
            ]
        ]
        
        // Act: try parsing the JSON
        let parsedItem = LootDetailsItem.sharingParse(sharingJSON: json)
        
        // Assert: ensure parsing returns nil due to excluded ID
        XCTAssertNil(parsedItem, "Parsing should return nil for excluded ID")
    }

    /// Test parsing valid LootItemStats JSON
    internal func testLootItemStatsParsingValid() {
        // Arrange: create a valid JSON for stats
        let json: [String: Any] = [
            "DmgPB": 75.0,
            "FiringRate": 1.2,
            "ClipSize": 25,
            "ReloadTime": 2.5,
            "BulletsPerCartridge": 30,
            "Spread": 0.2,
            "SpreadDownsights": 0.1,
            "DamageZone_Critical": 1.8
        ]
        
        // Act: parse the stats
        let parsedStats = LootItemStats.sharingParse(sharingJSON: json)
        
        // Assert: check if stats are parsed correctly
        XCTAssertNotNil(parsedStats, "Stats parsing should succeed for valid JSON")
        XCTAssertEqual(parsedStats?.dmgBullet, 75.0)
        XCTAssertEqual(parsedStats?.firingRate, 1.2)
        XCTAssertEqual(parsedStats?.clipSize, 25)
        XCTAssertEqual(parsedStats?.reloadTime, 2.5)
        XCTAssertEqual(parsedStats?.inCartridge, 30)
        XCTAssertEqual(parsedStats?.spread, 0.2)
        XCTAssertEqual(parsedStats?.downsight, 0.1)
        XCTAssertEqual(parsedStats?.zoneCritical, 1.8)
    }

    /// Test parsing an invalid LootItemStats JSON with missing fields
    internal func testLootItemStatsParsingInvalid() {
        // Arrange: create an invalid stats JSON with missing required fields
        let json: [String: Any] = [
            "DmgPB": 50.0
            // Missing other required fields like FiringRate, ClipSize, etc.
        ]
        
        // Act: try parsing the stats
        let parsedStats = LootItemStats.sharingParse(sharingJSON: json)
        
        // Assert: ensure parsing fails
        XCTAssertNil(parsedStats, "Parsing should fail for invalid stats JSON")
    }
}
