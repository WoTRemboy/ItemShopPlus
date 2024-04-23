//
//  JSONLootDetailsParse.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import Foundation

extension LootDetailsItem {
    static func sharingParse(sharingJSON: Any) -> LootDetailsItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let enabled = data["enabled"] as? Bool,
              let name = data["name"] as? String,
              let rarityData = data["rarity"] as? String,
              let typeData = data["type"] as? String,
              let imageData = data["images"] as? [String: Any],
              let statsData = data["mainStats"] as? [String: Any]
        else {
            return nil
        }
        
        let description = data["description"] as? String ?? String()
        let rarity = SelectingMethods.selectRarity(rarityText: rarityData)
        let type = LootItemType.selectingLootType(type: typeData)
        let image = imageData["background"] as? String ?? String()
        let stats = LootItemStats.sharingParse(sharingJSON: statsData) ?? LootItemStats.emptyStats
        
        let searchTagsData = data["searchTags"] as? String
        let searchTags = searchTagsData?.split(separator: " ").map({ String($0) }) ?? []
        
        return LootDetailsItem(id: id, enabled: enabled, name: name, description: description, rarity: rarity, type: type, searchTags: searchTags, image: image, stats: stats)
    }
}

extension LootItemStats {
    static func sharingParse(sharingJSON: Any) -> LootItemStats? {
        guard let data = sharingJSON as? [String: Any],
              let dmgBullet = data["DmgPB"] as? Int,
              let firingRate = data["FiringRate"] as? Int,
              let clipSize = data["ClipSize"] as? Int,
              let reloadTime = data["ReloadTime"] as? Double,
              let inCartridge = data["BulletsPerCartridge"] as? Int,
              let spread = data["Spread"] as? Double,
              let downsight = data["SpreadDownsights"] as? Double,
              let zoneCritical = data["DamageZone_Critical"] as? Double
        else {
            return nil
        }
        
        return LootItemStats(dmgBullet: dmgBullet, firingRate: firingRate, clipSize: clipSize, reloadTime: reloadTime, inCartridge: inCartridge, spread: spread, downsight: downsight, zoneCritical: zoneCritical)
    }
}
