//
//  JSONBattlePassTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class JSONBattlePassParseTests: XCTestCase {
    
    /// Test parsing of BattlePass from JSON
    internal func testBattlePassParsing() {
        // Sample JSON for a BattlePass
        let json: [String: Any] = [
            "season": 1,
            "displayInfo": [
                "chapter": "Chapter 2",
                "chapterSeason": "Season 3",
                "battlepassName": "BattlePass Alpha"
            ],
            "seasonDates": [
                "begin": "2024-02-01T00:00:00.000Z",
                "end": "2024-03-01T00:00:00.000Z"
            ],
            "videos": [
                ["url": "https://video-url.com"]
            ],
            "rewards": [
                [
                    "offerId": "item1",
                    "tier": 1,
                    "page": 1,
                    "battlepass": "paid",
                    "rewardsNeededForUnlock": 10,
                    "levelsNeededForUnlock": 1,
                    "price": ["amount": 100],
                    "item": [
                        "name": "Reward Item 1",
                        "type": ["name": "Type A"],
                        "rarity": ["id": "common"],
                        "added": ["date": "2024-02-15"],
                        "images": [
                            "icon_background": "https://image-url.com/icon.png",
                            "full_background": "https://image-url.com/full.png"
                        ],
                        "description": "A special item.",
                        "video": "https://video-url-item1.com"
                    ]
                ]
            ]
        ]
        
        // Parse the BattlePass
        let parsedBattlePass = BattlePass.sharingParse(sharingJSON: json)
        
        // Assertions to verify the parsed BattlePass
        XCTAssertNotNil(parsedBattlePass)
        XCTAssertEqual(parsedBattlePass?.id, 1)
        XCTAssertEqual(parsedBattlePass?.chapter, "Chapter 2")
        XCTAssertEqual(parsedBattlePass?.season, "Season 3")
        XCTAssertEqual(parsedBattlePass?.passName, "BattlePass Alpha")
        XCTAssertEqual(parsedBattlePass?.beginDate, beginEndDateFormatter("2024-02-01T00:00:00.000Z"))
        XCTAssertEqual(parsedBattlePass?.endDate, beginEndDateFormatter("2024-03-01T00:00:00.000Z"))
        XCTAssertEqual(parsedBattlePass?.video, "https://video-url.com")
        XCTAssertEqual(parsedBattlePass?.items.count, 1)
    }

    /// Test parsing of BattlePassItem from JSON
    internal func testBattlePassItemParsing() {
        // Sample JSON for a BattlePassItem
        let json: [String: Any] = [
            "offerId": "item2",
            "tier": 2,
            "page": 2,
            "battlepass": "free",
            "rewardsNeededForUnlock": 15,
            "levelsNeededForUnlock": 2,
            "price": ["amount": 200],
            "item": [
                "name": "Reward Item 2",
                "type": ["name": "Type B"],
                "rarity": ["id": "rare"],
                "added": ["date": "2024-02-20"],
                "images": [
                    "icon_background": "https://image-url.com/icon2.png",
                    "full_background": "https://image-url.com/full2.png"
                ],
                "description": "A rare item.",
                "video": "https://video-url-item2.com"
            ]
        ]
        
        // Parse the BattlePassItem
        let parsedItem = BattlePassItem.sharingParse(sharingJSON: json)
        
        // Assertions to verify the parsed BattlePassItem
        XCTAssertNotNil(parsedItem)
        XCTAssertEqual(parsedItem?.id, "item2")
        XCTAssertEqual(parsedItem?.tier, 2)
        XCTAssertEqual(parsedItem?.page, 2)
        XCTAssertEqual(parsedItem?.payType, .free)
        XCTAssertEqual(parsedItem?.price, 200)
        XCTAssertEqual(parsedItem?.rewardWall, 15)
        XCTAssertEqual(parsedItem?.levelWall, 2)
        XCTAssertEqual(parsedItem?.name, "Reward Item 2")
        XCTAssertEqual(parsedItem?.type, "Type B")
        XCTAssertEqual(parsedItem?.rarity, .rare)
        XCTAssertEqual(parsedItem?.releaseDate, releaseDateFormatter("2024-02-20"))
        XCTAssertEqual(parsedItem?.image, "https://image-url.com/icon2.png")
        XCTAssertEqual(parsedItem?.shareImage, "https://image-url.com/full2.png")
        XCTAssertEqual(parsedItem?.description, "A rare item.")
        XCTAssertEqual(parsedItem?.video, "https://video-url-item2.com")
    }
    
    // MARK: - Date Formatting Methods
    
    /// Converts a given date string in the format "yyyy-MM-dd" into a `Date` object
    /// - Parameter dateString: A string representing the date in the format "yyyy-MM-dd"
    /// - Returns: A `Date` object corresponding to the date string, or the current date if parsing fails
    private func releaseDateFormatter(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    /// Converts a given date string in the format "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" into a `Date` object
    /// - Parameter dateString: A string representing the date and time in the format "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    /// - Returns: A `Date` object corresponding to the date string, or the current date if parsing fails
    private func beginEndDateFormatter(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
