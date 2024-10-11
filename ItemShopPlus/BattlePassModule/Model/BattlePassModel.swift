//
//  BattlePassModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.03.2024.
//

import Foundation

// MARK: - BattlePass

/// Represents a Battle Pass structure containing relevant information such as chapter, season, name, and items
struct BattlePass {
    /// Unique identifier of the Battle Pass
    let id: Int
    /// Chapter of the Battle Pass (e.g., "Chapter 3")
    let chapter: String
    /// Season of the Battle Pass (e.g., "Season 2")
    let season: String
    /// Name of the Battle Pass (e.g., "Heroes and Legends")
    let passName: String
    /// The beginning date of the Battle Pass
    let beginDate: Date
    /// The ending date of the Battle Pass
    let endDate: Date
    /// URL string to a video trailer or overview of the Battle Pass
    let video: String?
    /// Array of items included in the Battle Pass
    let items: [BattlePassItem]
    
    /// A placeholder instance of `BattlePass` to represent an empty or error state
    static let emptyPass = BattlePass(id: 0, chapter: "Chapter X", season: "Season X", passName: "Error Pass", beginDate: .now, endDate: .now, video: nil, items: [BattlePassItem.emptyItem])
}

// MARK: - BattlePassItem

/// Represents an individual item within a Battle Pass
struct BattlePassItem {
    /// Unique identifier of the Battle Pass item
    let id: String
    /// The tier at which this item is unlocked in the Battle Pass
    let tier: Int
    /// The page number where this item is displayed in the Battle Pass UI
    let page: Int
    /// Indicates whether the item is a free or paid reward in the Battle Pass
    let payType: PayType
    /// The price required to unlock the item
    let price: Int
    /// Rewards required to unlock the item
    let rewardWall: Int
    /// The level required to unlock the item
    let levelWall: Int
    
    /// Type of the battle pass item (e.g., "Outfit", "Emote", etc.)
    let type: String
    /// Name of the battle pass item
    let name: String
    /// Description of the battle pass item
    let description: String
    /// Rarity of the battle pass item
    let rarity: Rarity
    /// Series to which this item belongs
    let series: String?
    /// Date the item was first released
    let releaseDate: Date
    /// URL string to the image representing this item
    let image: String
    /// URL string to the shareable image of this item
    let shareImage: String
    /// URL string to a video preview of the item, if available
    let video: String?
    /// Introduction text associated with the item
    let introduction: String
    /// Set to which the item belongs, if applicable
    let set: String?
    
    /// A placeholder instance of `BattlePassItem` to represent an empty or error state
    static let emptyItem = BattlePassItem(id: "", tier: 0, page: 0, payType: .paid, price: 0, rewardWall: 0, levelWall: 0, type: "", name: "", description: "", rarity: .common, series: nil, releaseDate: .now, image: "", shareImage: "", video: "", introduction: "", set: "")
}

// MARK: - PayType

/// Enum representing the type of reward in a Battle Pass (free or paid)
enum PayType {
    case free
    case paid
}
