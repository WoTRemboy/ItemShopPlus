//
//  LootDetailsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import Foundation

struct LootDetailsItem {
    let id: String
    let enabled: Bool
    let name: String
    let description: String
    let rarity: Rarity
    let type: LootItemType
    let searchTags: [String]
    let image: String
    let stats: LootItemStats
}

struct LootItemStats {
    let dmgBullet: Int
    let firingRate: Int
    let clipSize: Int
    let reloadTime: Double
    let inCartridge: Int
    let spread: Double
    let downsight: Double
    let zoneCritical: Double
    
    static let emptyStats = LootItemStats(dmgBullet: 0, firingRate: 0, clipSize: 0, reloadTime: 0, inCartridge: 0, spread: 0, downsight: 0, zoneCritical: 0)
}

enum LootItemType {
    case standart
    case starWars
    case seasonal
    case boss
    case sword
    
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
