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
              let anotherData = data["bundles"] as? [[String: Any]]
        else {
            return nil
        }
        
        var startDate: String?, endDate: String?
        var questsData: [[String: Any]] = [[:]]
        for questsDatum in anotherData {
            if let activeDates = questsDatum["activeDates"] as? [String: Any] {
                startDate = activeDates["start"] as? String
                endDate = activeDates["end"] as? String
            }
            questsData = questsDatum["quests"] as? [[String: Any]] ?? [[:]]
        }
        let start: Date? = DateFormating.dateFormatter.date(from: startDate ?? Texts.Season.beginDate)
        let end = DateFormating.dateFormatter.date(from: endDate ?? Texts.Season.endDate)
        
        let questsList = questsData.compactMap { Quest.sharingParse(sharingJSON: $0) }
        print(questsList)
        
        return QuestBundle(tag: tag, name: name, image: image, startDate: start, endDate: end, quests: questsList)
    }
}

extension Quest {
    static func sharingParse(sharingJSON: Any) -> Quest? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let name = data["name"] as? String,
              let enabled = data["enabled"] as? Bool,
              let progress = data["progressTotal"] as? Int,
              let rewards = data["reward"] as? [String: Any]
        else {
            return nil
        }
        
        let xpReward = rewards["xp"] as? String
        
        var itemReward: String?, image: String?
        if let itemRewardData = rewards["items"] as? [[String: Any]] {
            for datum in itemRewardData {
                itemReward = datum["name"] as? String
                if let imageData = datum["images"] as? [String: Any] {
                    image = imageData["background"] as? String
                }
                
            }
        }
        
        return Quest(id: id, name: name, enabled: enabled, enabledDate: nil, parentQuest: nil, xpReward: xpReward, itemReward: itemReward, progress: String(progress), image: image)
    }
}
