//
//  LootDetailsModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class LootTests: XCTestCase {
    
    /// Test LootItemType selection logic
    internal func testLootItemTypeSelection() {
        XCTAssertEqual(LootItemType.selectingLootType(type: "standart"), .standart)
        XCTAssertEqual(LootItemType.selectingLootType(type: "starwars"), .starWars)
        XCTAssertEqual(LootItemType.selectingLootType(type: "seasonal"), .seasonal)
        XCTAssertEqual(LootItemType.selectingLootType(type: "boss"), .boss)
        XCTAssertEqual(LootItemType.selectingLootType(type: "sword"), .sword)
        XCTAssertEqual(LootItemType.selectingLootType(type: "unknown"), .standart) // Unknown type should return .standart by default
    }
    
    /// Test LootDetailsItem initialization with empty details
    internal func testEmptyLootDetailsItem() {
        let emptyItem = LootDetailsItem.emptyLootDetails
        
        XCTAssertEqual(emptyItem.id, "")
        XCTAssertEqual(emptyItem.enabled, false)
        XCTAssertEqual(emptyItem.name, "")
        XCTAssertEqual(emptyItem.description, "")
        XCTAssertEqual(emptyItem.rarity, .common)
        XCTAssertEqual(emptyItem.type, .standart)
        XCTAssertTrue(emptyItem.searchTags.isEmpty)
        XCTAssertEqual(emptyItem.mainImage, "")
        XCTAssertEqual(emptyItem.rarityImage, "")
    }
    
    /// Test LootItemStats empty stats
    internal func testEmptyLootItemStats() {
        let emptyStats = LootItemStats.emptyStats
        
        XCTAssertEqual(emptyStats.dmgBullet, 0)
        XCTAssertEqual(emptyStats.firingRate, 0)
        XCTAssertEqual(emptyStats.clipSize, 0)
        XCTAssertEqual(emptyStats.reloadTime, 0)
        XCTAssertEqual(emptyStats.inCartridge, 0)
        XCTAssertEqual(emptyStats.spread, 0)
        XCTAssertEqual(emptyStats.downsight, 0)
        XCTAssertEqual(emptyStats.zoneCritical, 0)
        XCTAssertEqual(emptyStats.availableStats, -1) // availableStats should be -1 for empty stats
    }
    
    /// Test LootDetailsItem initialization with custom data
    internal func testCustomLootDetailsItem() {
        let stats = LootItemStats(dmgBullet: 50, firingRate: 0.8, clipSize: 30, reloadTime: 2.5, inCartridge: 10, spread: 0.1, downsight: 1.2, zoneCritical: 2.0, availableStats: 5)
        
        let customItem = LootDetailsItem(
            id: "001",
            enabled: true,
            name: "Epic Sword",
            description: "A legendary sword",
            rarity: .epic,
            type: .sword,
            searchTags: ["melee", "legendary"],
            mainImage: "epic_sword.png",
            rarityImage: "epic_rarity.png",
            stats: stats
        )
        
        XCTAssertEqual(customItem.id, "001")
        XCTAssertEqual(customItem.enabled, true)
        XCTAssertEqual(customItem.name, "Epic Sword")
        XCTAssertEqual(customItem.description, "A legendary sword")
        XCTAssertEqual(customItem.rarity, .epic)
        XCTAssertEqual(customItem.type, .sword)
        XCTAssertEqual(customItem.searchTags, ["melee", "legendary"])
        XCTAssertEqual(customItem.mainImage, "epic_sword.png")
        XCTAssertEqual(customItem.rarityImage, "epic_rarity.png")
        XCTAssertEqual(customItem.stats.dmgBullet, 50)
        XCTAssertEqual(customItem.stats.firingRate, 0.8)
        XCTAssertEqual(customItem.stats.clipSize, 30)
        XCTAssertEqual(customItem.stats.reloadTime, 2.5)
        XCTAssertEqual(customItem.stats.inCartridge, 10)
        XCTAssertEqual(customItem.stats.spread, 0.1)
        XCTAssertEqual(customItem.stats.downsight, 1.2)
        XCTAssertEqual(customItem.stats.zoneCritical, 2.0)
        XCTAssertEqual(customItem.stats.availableStats, 5)
    }
    
    /// Test LootNamedItems initialization
    internal func testLootNamedItems() {
        let stats = LootItemStats(dmgBullet: 10, firingRate: 1.2, clipSize: 5, reloadTime: 1.5, inCartridge: 2, spread: 0.2, downsight: 1.0, zoneCritical: 1.5, availableStats: 4)
        let item1 = LootDetailsItem(id: "001", enabled: true, name: "Item 1", description: "Test item 1", rarity: .rare, type: .standart, searchTags: ["test"], mainImage: "item1.png", rarityImage: "rare.png", stats: stats)
        let item2 = LootDetailsItem(id: "002", enabled: false, name: "Item 2", description: "Test item 2", rarity: .legendary, type: .seasonal, searchTags: ["test", "legendary"], mainImage: "item2.png", rarityImage: "legendary.png", stats: stats)
        
        let namedItems = LootNamedItems(name: "Test Loot", items: [item1, item2])
        
        XCTAssertEqual(namedItems.name, "Test Loot")
        XCTAssertEqual(namedItems.items.count, 2)
        XCTAssertEqual(namedItems.items[0].name, "Item 1")
        XCTAssertEqual(namedItems.items[1].name, "Item 2")
    }
}
