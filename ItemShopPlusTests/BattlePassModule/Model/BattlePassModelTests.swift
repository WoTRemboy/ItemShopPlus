//
//  BattlePassModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/29/24.
//

import XCTest
@testable import ItemShopPlus

final class BattlePassTests: XCTestCase {
    
    // Test for initializing a BattlePass
    internal func testBattlePassInitialization() {
        let beginDate = Date() // Current date as the start date
        let endDate = Date().addingTimeInterval(60 * 60 * 24) // 1 day later as the end date
        
        // Creating a sample array of BattlePassItem
        let items: [BattlePassItem] = [
            BattlePassItem(id: "item1", tier: 1, page: 1, payType: .paid, price: 100, rewardWall: 10, levelWall: 1, type: "Type A", name: "Item A", description: "This is item A", rarity: .common, series: nil, releaseDate: Date(), image: "imageA.png", shareImage: "shareImageA.png", video: "videoA.mp4", introduction: "Intro to item A", set: nil)
        ]
        
        // Initializing the BattlePass with sample data
        let battlePass = BattlePass(id: 1, chapter: "Chapter 1", season: "Season 1", passName: "Battle Pass 1", beginDate: beginDate, endDate: endDate, video: "video.mp4", items: items)
        
        // Assertions to verify the properties of the initialized BattlePass
        XCTAssertEqual(battlePass.id, 1)
        XCTAssertEqual(battlePass.chapter, "Chapter 1")
        XCTAssertEqual(battlePass.season, "Season 1")
        XCTAssertEqual(battlePass.passName, "Battle Pass 1")
        XCTAssertEqual(battlePass.beginDate, beginDate)
        XCTAssertEqual(battlePass.endDate, endDate)
        XCTAssertEqual(battlePass.video, "video.mp4")
        XCTAssertEqual(battlePass.items.count, 1) // Ensure there's one item in the array
    }

    // Test for initializing a BattlePassItem
    internal func testBattlePassItemInitialization() {
        let releaseDate = Date() // Current date as the release date
        
        // Initializing a BattlePassItem with sample data
        let battlePassItem = BattlePassItem(id: "item2", tier: 2, page: 1, payType: .free, price: 0, rewardWall: 5, levelWall: 1, type: "Type B", name: "Item B", description: "This is item B", rarity: .rare, series: "Series 1", releaseDate: releaseDate, image: "imageB.png", shareImage: "shareImageB.png", video: nil, introduction: "Intro to item B", set: "Set 1")
        
        // Assertions to verify the properties of the initialized BattlePassItem
        XCTAssertEqual(battlePassItem.id, "item2")
        XCTAssertEqual(battlePassItem.tier, 2)
        XCTAssertEqual(battlePassItem.page, 1)
        XCTAssertEqual(battlePassItem.payType, .free)
        XCTAssertEqual(battlePassItem.price, 0)
        XCTAssertEqual(battlePassItem.rewardWall, 5)
        XCTAssertEqual(battlePassItem.levelWall, 1)
        XCTAssertEqual(battlePassItem.type, "Type B")
        XCTAssertEqual(battlePassItem.name, "Item B")
        XCTAssertEqual(battlePassItem.description, "This is item B")
        XCTAssertEqual(battlePassItem.rarity, .rare)
        XCTAssertEqual(battlePassItem.series, "Series 1")
        XCTAssertEqual(battlePassItem.releaseDate, releaseDate)
        XCTAssertEqual(battlePassItem.image, "imageB.png")
        XCTAssertEqual(battlePassItem.shareImage, "shareImageB.png")
        XCTAssertNil(battlePassItem.video) // Video is nil
        XCTAssertEqual(battlePassItem.introduction, "Intro to item B")
        XCTAssertEqual(battlePassItem.set, "Set 1")
    }

    // Test for the empty BattlePass static instance
    internal func testEmptyBattlePass() {
        let emptyPass = BattlePass.emptyPass // Access the static empty instance
        
        // Assertions to verify the properties of the empty BattlePass
        XCTAssertEqual(emptyPass.id, 0)
        XCTAssertEqual(emptyPass.chapter, "Chapter X")
        XCTAssertEqual(emptyPass.season, "Season X")
        XCTAssertEqual(emptyPass.passName, "Error Pass")
        XCTAssertNil(emptyPass.video) // Video is nil
        XCTAssertEqual(emptyPass.items.count, 1) // Ensure there's one empty item
        XCTAssertEqual(emptyPass.items.first?.id, "") // Ensure the ID of the empty item is an empty string
    }

    // Test for the empty BattlePassItem static instance
    internal func testEmptyBattlePassItem() {
        let emptyItem = BattlePassItem.emptyItem // Access the static empty instance
        
        // Assertions to verify the properties of the empty BattlePassItem
        XCTAssertEqual(emptyItem.id, "")
        XCTAssertEqual(emptyItem.tier, 0)
        XCTAssertEqual(emptyItem.page, 0)
        XCTAssertEqual(emptyItem.payType, .paid) // Default pay type
        XCTAssertEqual(emptyItem.price, 0)
        XCTAssertEqual(emptyItem.rewardWall, 0)
        XCTAssertEqual(emptyItem.levelWall, 0)
        XCTAssertEqual(emptyItem.type, "")
        XCTAssertEqual(emptyItem.name, "")
        XCTAssertEqual(emptyItem.description, "")
        XCTAssertEqual(emptyItem.rarity, .common) // Default rarity
        XCTAssertNil(emptyItem.series) // Series is nil
        XCTAssertEqual(emptyItem.image, "")
        XCTAssertEqual(emptyItem.shareImage, "")
        XCTAssertEqual(emptyItem.video, "")
        XCTAssertEqual(emptyItem.introduction, "")
        XCTAssertEqual(emptyItem.set, "")
    }
}
