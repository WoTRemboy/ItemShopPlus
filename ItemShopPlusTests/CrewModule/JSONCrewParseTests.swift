//
//  JSONCrewParseTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class JSONCrewParseTests: XCTestCase {
    
    // Test parsing a valid CrewPack JSON
    internal func testCrewPackParsing() {
        let json: [String: Any] = [
            "prices": [
                ["paymentCurrencyCode": "USD", "paymentCurrencySymbol": "$", "paymentCurrencyAmountNatural": 11.99]
            ],
            "currentCrew": [
                "descriptions": [
                    "title": "February Crew Pack",
                    "battlepass": "Battle Pass Included",
                    "vbucksTitle": "1000 V-Bucks"
                ],
                "rewards": [
                    [
                        "item": [
                            "id": "item1",
                            "type": ["id": "outfit", "name": "Skin"],
                            "name": "Exclusive Outfit",
                            "description": "An exclusive outfit for crew members.",
                            "images": [
                                "icon_background": "https://example.com/item.png",
                                "full_background": "https://example.com/full.png"
                            ],
                            "rarity": ["id": "legendary"],
                            "introduction": ["text": "Chapter 2: Season 5"]
                        ]
                    ]
                ],
                "images": ["apiRender": "https://example.com/pack.png"],
                "date": "2024-02-25"
            ]
        ]
        
        guard let crewPack = CrewPack.sharingParse(sharingJSON: json) else {
            XCTFail("Failed to parse CrewPack")
            return
        }
        
        // Verify CrewPack properties
        XCTAssertEqual(crewPack.title, "February Crew Pack")
        XCTAssertEqual(crewPack.battlePassTitle, "Battle Pass Included")
        XCTAssertEqual(crewPack.addPassTitle, "1000 V-Bucks")
        XCTAssertEqual(crewPack.image, "https://example.com/pack.png")
        XCTAssertEqual(crewPack.date, "February")
        XCTAssertEqual(crewPack.price.count, 1)
        XCTAssertEqual(crewPack.price.first?.price, 11.99)
        
        // Verify CrewItem properties
        XCTAssertEqual(crewPack.items.count, 1)
        let crewItem = crewPack.items.first!
        XCTAssertEqual(crewItem.id, "item1")
        XCTAssertEqual(crewItem.type, "Skin")
        XCTAssertEqual(crewItem.name, "Exclusive Outfit")
        XCTAssertEqual(crewItem.description, "An exclusive outfit for crew members.")
        XCTAssertEqual(crewItem.image, "https://example.com/item.png")
        XCTAssertEqual(crewItem.shareImage, "https://example.com/full.png")
        XCTAssertEqual(crewItem.rarity, .legendary)
        XCTAssertEqual(crewItem.introduction, "Season 5")
        XCTAssertTrue(crewItem.video)
    }
    
    // Test parsing a CrewItem JSON
    internal func testCrewItemParsing() {
        let json: [String: Any] = [
            "item": [
                "id": "item2",
                "type": ["id": "backpack", "name": "Back Bling"],
                "name": "Crew Backpack",
                "description": "A stylish backpack for the crew.",
                "images": [
                    "icon_background": "https://example.com/backpack.png",
                    "full_background": "https://example.com/full_backpack.png"
                ],
                "rarity": ["id": "epic"],
                "introduction": ["text": "Chapter 2: Season 5"]
            ]
        ]
        
        guard let crewItem = CrewItem.sharingParse(sharingJSON: json) else {
            XCTFail("Failed to parse CrewItem")
            return
        }
        
        // Verify CrewItem properties
        XCTAssertEqual(crewItem.id, "item2")
        XCTAssertEqual(crewItem.type, "Backpack")
        XCTAssertEqual(crewItem.name, "Crew Backpack")
        XCTAssertEqual(crewItem.description, "A stylish backpack for the crew.")
        XCTAssertEqual(crewItem.image, "https://example.com/backpack.png")
        XCTAssertEqual(crewItem.shareImage, "https://example.com/full_backpack.png")
        XCTAssertEqual(crewItem.rarity, .epic)
        XCTAssertEqual(crewItem.introduction, "Season 5")
        XCTAssertFalse(crewItem.video) // Since it's not an outfit
    }
    
    // Test invalid CrewPack parsing
    internal func testInvalidCrewPackParsing() {
        let invalidJson: [String: Any] = [
            "invalidKey": "invalidValue"
        ]
        
        let crewPack = CrewPack.sharingParse(sharingJSON: invalidJson)
        
        // CrewPack should be nil for invalid JSON
        XCTAssertNil(crewPack)
    }
    
    // Test invalid CrewItem parsing
    internal func testInvalidCrewItemParsing() {
        let invalidJson: [String: Any] = [
            "invalidKey": "invalidValue"
        ]
        
        let crewItem = CrewItem.sharingParse(sharingJSON: invalidJson)
        
        // CrewItem should be nil for invalid JSON
        XCTAssertNil(crewItem)
    }
}
