//
//  JSONLootDetailsParse.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import Foundation

// MARK: - LootDetailsItem JSON Parsing

extension LootDetailsItem {
    /// Parses the provided JSON object into a `LootDetailsItem` object
    /// - Parameter sharingJSON: The raw JSON object that contains the loot item data
    /// - Returns: A `LootDetailsItem` object if the parsing is successful, otherwise, `nil`
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
        
        // Splitting ID to filter out certain invalid items
        let splitedID = id.split(separator: "_")
        guard !splitedID.contains("Juno"), !splitedID.contains("Coal") else { return nil }
        
        let description = data["description"] as? String ?? String()
        let rarity = SelectingMethods.selectRarity(rarityText: rarityData)
        let type = LootItemType.selectingLootType(type: typeData)
        
        // Parse item stats
        let stats = LootItemStats.sharingParse(sharingJSON: statsData) ?? LootItemStats.emptyStats
        guard stats.availableStats > 0 else { return nil }
        
        // Parse search tags
        let searchTagsData = data["searchTags"] as? String
        let searchTags = searchTagsData?.split(separator: " ").map({ String($0) }) ?? []
        
        // Filtering out specific unwanted IDs
        guard id != "WID_HighTower_Mango_DualPistol_Auto_Heavy_Athena",
              id != "WID_WaffleTruck_SMG_RunGun",
              id != "WID_Assault_Chrono_BackPackMiniGun_Athena_R",
              id != "WID_WaffleTruck_Assault_BigMoney",
              id != "WID_WaffleTruck_Assault_Brrrrst",
              id != "WID_StudGun_ActivationSwitch",
              id != "WID_StudGun",
              id != "WID_Athena_AvacadoEaterThrown",
              id != "WID_BigWheelGrenade",
              id != "WID_ModBox_BulletproofTires_Spawner",
              id != "ChainGrenade",
              id != "WID_ModBox_CowCatcher_Spawner",
              id != "WID_Lime_Consumable_SlurpJuice",
              id != "WID_ModBox_Repair_Spawner",
              id != "WID_BigWheelGrenade",
              id != "WID_ThrowingToy_Basketball",
              id != "WID_Pilgrim_BandQuickPlay_Bass",
              id != "WID_Athena_BurstSquadHeal",
              id != "WID_Pilgrim_BandQuickPlay_Drums",
              id != "TID_Floor_Minigame_Trigger_Plate",
              id != "WID_VehicleMortarMod",
              id != "WID_Pilgrim_BandQuickPlay_Guitar",
              id != "WID_Pilgrim_BandQuickPlay_Keytar",
              id != "Athena_Intel_Pack",
              id != "WID_VehicleMachineGunMod",
              id != "WID_TinStack",
              id != "TID_Floor_VehicleSpawner",
              id != "WID_Pilgrim_BandQuickPlay_Mic",
              id != "WID_WheelGrenade"
        else { return nil }
        
        return LootDetailsItem(id: id, enabled: enabled, name: name, description: description, rarity: rarity, type: type, searchTags: searchTags, mainImage: mainImage, rarityImage: rarityImage, stats: stats)
    }
}

// MARK: - LootItemStats JSON Parsing

extension LootItemStats {
    /// Parses the provided JSON object into a `LootItemStats` object
    /// - Parameter sharingJSON: The raw JSON object that contains the item stats data
    /// - Returns: A `LootItemStats` object if the parsing is successful, otherwise, `nil`
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
        
        // Counting available stats
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
