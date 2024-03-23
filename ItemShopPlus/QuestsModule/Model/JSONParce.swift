//
//  JSONParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.12.2023.
//

import Foundation

extension QuestBundle {
    static func sharingParse(sharingJSON: Any) -> QuestBundle? {
        guard let data = sharingJSON as? [String: Any],
              let tag = data["tag"] as? String,
              let name = data["name"] as? String,
              let image = data["image"] as? String,
              let subBundlesData = data["bundles"] as? [[String: Any]]
        else {
            return nil
        }
        
        let subBundles = subBundlesData.compactMap { QuestSubBundle.sharingParse(sharingJSON: $0) }
        
        return QuestBundle(tag: tag, name: name, image: image, subBundles: subBundles)
    }
}

extension QuestSubBundle {
    static func sharingParse(sharingJSON: Any) -> QuestSubBundle? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let name = data["name"] as? String,
              let header = data["header"] as? String,
              let questsData = data["quests"] as? [[String: Any]]
        else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var beginDate: Date? = nil
        var endDate: Date? = nil
        if let dateString = data["activeDates"] as? [String: Any] {
            let beginDateString = dateString["start"] as? String
            let endDateString = dateString["end"] as? String
            beginDate = dateFormatter.date(from: beginDateString ?? String())
            endDate = dateFormatter.date(from: endDateString ?? String())
        }

        let quests = questsData.compactMap { Quest.sharingParse(sharingJSON: $0) }
        
        return QuestSubBundle(id: id, name: name, beginDate: beginDate, endDate: endDate, header: header, quests: quests)
    }
}

extension Quest {
    static func sharingParse(sharingJSON: Any) -> Quest? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let name = data["name"] as? String,
              let enabled = data["enabled"] as? Bool,
              let progress = data["progressTotal"] as? Int,
              let rewards = data["reward"] as? [String: Any],
              enabled == true
        else {
            return nil
        }
        
        let description = data["description"] as? String
        let shortDescription = data["shortDescription"] as? String
        let categoryHeader = data["categoryHeader"] as? String
        let parentQuest = data["parentQuest"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        var enabledDate: Date? = nil
        if let enabledDateString = data["enabledDate"] as? String {
            enabledDate = dateFormatter.date(from: enabledDateString)
        }
        
        var itemRewards = [QuestItem]()
        let xpReward = rewards["xp"] as? Int
        if let itemRewardData = rewards["items"] as? [[String: Any]] {
            itemRewards = itemRewardData.compactMap { QuestItem.sharingParse(sharingJSON: $0) }
        }
        
        return Quest(id: id, name: name, description: description, shortDescription: shortDescription, categoryHeader: categoryHeader, enabled: enabled, enabledDate: enabledDate, parentQuest: parentQuest, progress: progress, xpReward: xpReward, itemReward: itemRewards)
    }
}

extension QuestItem {
    static func sharingParse(sharingJSON: Any) -> QuestItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let typeData = data["type"] as? [String: Any],
              let type = typeData["name"] as? String,
              let name = data["name"] as? String,
              let rariryData = data["rarity"] as? [String: Any],
              let imagesData = data["images"] as? [String: Any],
              let image = imagesData["icon_background"] as? String
        else {
            return nil
        }
        
        let rarity = SelectingMethods.selectRarity(rarityText: rariryData["id"] as? String)
        let series = data["series"] as? String
        
        return QuestItem(id: id, type: type, name: name, rarity: rarity, series: series, image: image)
    }
}
