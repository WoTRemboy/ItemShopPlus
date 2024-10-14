//
//  LootDetailsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import Foundation

// MARK: - LootNamedItems

/// A struct that groups loot items under a specific category
struct LootNamedItems {
    /// The name of the loot category
    let name: String
    /// An array of loot items within this category
    var items: [LootDetailsItem]
}

// MARK: - LootDetailsItem

/// A struct that represents the details of a specific loot item
struct LootDetailsItem {
    /// A unique identifier for the loot item
    let id: String
    /// Indicates whether the item is available in the shop
    let enabled: Bool
    /// The name of the loot item
    let name: String
    /// A description of the item
    let description: String
    /// The rarity of the item (e.g., common, rare)
    let rarity: Rarity
    /// The type of the loot item (e.g., standard, starWars)
    let type: LootItemType
    /// Tags associated with the item to help with searches
    let searchTags: [String]
    /// The URL or path to the main image representing the item
    let mainImage: String
    /// The URL or path to the image representing the item's rarity
    let rarityImage: String
    /// A struct containing the stats of the loot item
    let stats: LootItemStats
    
    /// A placeholder instance of `LootDetailsItem` to represent an empty or error state
    static let emptyLootDetails = LootDetailsItem(id: "", enabled: false, name: "", description: "", rarity: .common, type: .standart, searchTags: [], mainImage: "", rarityImage: "", stats: .emptyStats)
}

// MARK: - LootItemStats

/// A struct that represents the detailed statistics of a loot item
struct LootItemStats {
    /// Damage per bullet
    let dmgBullet: Double
    /// Rate of fire (bullets per second)
    let firingRate: Double
    /// Size of the ammo clip
    let clipSize: Int
    /// Time it takes to reload the weapon
    let reloadTime: Double
    /// Number of rounds in the cartridge
    let inCartridge: Int
    /// Bullet spread (accuracy factor)
    let spread: Double
    /// Accuracy when aiming down the sights
    let downsight: Double
    /// Damage multiplier for critical hit zones
    let zoneCritical: Double
    /// Indicates how many stats are available for the item
    let availableStats: Int
    
    /// A placeholder instance of `LootItemStats` to represent an empty or error state
    static let emptyStats = LootItemStats(dmgBullet: 0, firingRate: 0, clipSize: 0, reloadTime: 0, inCartridge: 0, spread: 0, downsight: 0, zoneCritical: 0, availableStats: -1)
}

// MARK: - LootItemType

/// An enum that categorizes loot items into different types (e.g., standard, starWars, seasonal)
enum LootItemType {
    // Standard type of loot
    case standart
    // Star Wars themed loot
    case starWars
    // Seasonal loot items
    case seasonal
    // Boss-level loot items
    case boss
    // Sword loot items
    case sword
    
    /// Selects and returns the corresponding `LootItemType` based on a string input.
    /// - Parameter type: String that represents the type of loot (e.g., "standart", "starwars").
    /// - Returns: The corresponding `LootItemType` enum value based on the input string. If the input string does not match any case, it returns `.standart`.
    static func selectingLootType(type: String) -> LootItemType {
        switch type {
        case "standart":
            return .standart
        case "starwars":
            return .starWars
        case "seasonal":
            return .seasonal
        case "boss":
            return .boss
        case "sword":
            return .sword
        default:
            return .standart
        }
    }
}

// MARK: - LootItemGameType

/// An enum that defines different game types for loot items
enum LootItemGameType {
    case weapon
    case health
    case trap
}
