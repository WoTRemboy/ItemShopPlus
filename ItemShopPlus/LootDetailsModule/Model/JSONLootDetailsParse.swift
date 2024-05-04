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
              let statsData = data["mainStats"] as? [String: Any],
              let mainImage = imageData["icon"] as? String,
              let rarityImage = imageData["background"] as? String
        else {
            return nil
        }
        
        guard id != "WID_Assault_Chrono_BackPackMiniGun_Athena_R",
              id != "WID_Pilgrim_BandQuickPlay_Bass",
              id != "WID_WaffleTruck_Assault_BigMoney",
              id != "WID_WaffleTruck_Assault_Brrrrst",
              id != "WID_Pilgrim_BandQuickPlay_Drums",
              id != "WID_FireExtinguisher_Spray",
              id != "WID_Ranged_Flashlight",
              id != "WID_Launcher_Petrol",
              id != "WID_Pilgrim_BandQuickPlay_Guitar",
              id != "WID_Pilgrim_BandQuickPlay_Keytar",
              id != "WID_Athena_HealSpray",
              id != "WID_HighTower_Mango_DualPistol_Auto_Heavy_Athena",
              id != "WID_WaffleTruck_SMG_RunGun",
              id != "WID_TinStack",
              id != "WID_Pilgrim_BandQuickPlay_Mic",
              id != "WID_Athena_BurstSquadHeal",
              id != "WID_Juno_Bow_T5",
              id != "WID_Paprika_TeamSpray_LowGrav",
              id != "WID_Juno_Enemy_Pumpkin",
              id != "WID_Juno_Dynamite",
              id != "WID_Juno_Enemy_Stud_Dummy",
              id != "WID_Juno_Enemy_Stud_Suburbian",
              id != "WID_Juno_Enemy_Stud_Fallback",
              id != "Athena_Spytech_R_TNT",
              id != "WID_Juno_Enemy_Dynamite_Bandit",
              id != "WID_Juno_Enemy_Dynamite_Pirate",
              id != "WID_Juno_Enemy_Dynamite_Skeleton",
              id != "WID_Juno_Enemy_Dynamite_Skeleton_Bandit",
              id != "WID_Juno_Enemy_Dynamite_Skeleton_Miner",
              id != "WID_Juno_Enemy_Dynamite_Skeleton_Pirate"
        else {
            return nil
        }
        
        let description = data["description"] as? String ?? String()
        let rarity = SelectingMethods.selectRarity(rarityText: rarityData)
        let type = LootItemType.selectingLootType(type: typeData)
        
        let stats = LootItemStats.sharingParse(sharingJSON: statsData) ?? LootItemStats.emptyStats
        guard stats.availableStats > 4 else { return nil }
        
        let searchTagsData = data["searchTags"] as? String
        let searchTags = searchTagsData?.split(separator: " ").map({ String($0) }) ?? []
        
        return LootDetailsItem(id: id, enabled: enabled, name: name, description: description, rarity: rarity, type: type, searchTags: searchTags, mainImage: mainImage, rarityImage: rarityImage, stats: stats)
    }
}

extension LootItemStats {
    static func sharingParse(sharingJSON: Any) -> LootItemStats? {
        guard let data = sharingJSON as? [String: Any],
              let dmgBullet = data["DmgPB"] as? Double,
              let firingRate = data["FiringRate"] as? Double,
              let clipSize = data["ClipSize"] as? Int,
              let reloadTime = data["ReloadTime"] as? Double,
              let inCartridge = data["BulletsPerCartridge"] as? Int,
              let spread = data["Spread"] as? Double,
              let downsight = data["SpreadDownsights"] as? Double,
              let zoneCritical = data["DamageZone_Critical"] as? Double
        else {
            return nil
        }
        
        var availableStats = 0
        if dmgBullet != 0 { availableStats += 1 }
        if firingRate != 0 { availableStats += 1 }
        if clipSize != 0 { availableStats += 1 }
        if reloadTime != 0 { availableStats += 1 }
        if inCartridge != 0 { availableStats += 1 }
        if spread != 0 { availableStats += 1 }
        if downsight != 0 { availableStats += 1 }
        if zoneCritical != 0 { availableStats += 1 }
        
        return LootItemStats(dmgBullet: dmgBullet, firingRate: firingRate, clipSize: clipSize, reloadTime: reloadTime, inCartridge: inCartridge, spread: spread, downsight: downsight, zoneCritical: zoneCritical, availableStats: availableStats)
    }
}
