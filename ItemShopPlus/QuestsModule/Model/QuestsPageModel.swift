//
//  QuestsPageModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import Foundation

struct QuestBundle: Equatable {
    let tag: String
    let name: String
    let image: String
    let startDate: Date?
    let endDate: Date?
    let quests: [Quest]
    
    init(tag: String, name: String, image: String, startDate: Date?, endDate: Date?, quests: [Quest]) {
        self.tag = tag
        self.name = name
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
        self.quests = quests
    }
    
    static func == (lhs: QuestBundle, rhs: QuestBundle) -> Bool {
            return lhs.tag == rhs.tag &&
                   lhs.name == rhs.name &&
                   lhs.image == rhs.image &&
                   lhs.startDate == rhs.startDate &&
                   lhs.endDate == rhs.endDate
        }
}

struct Quest: Identifiable {
    let id: String
    let name: String
    let enabled: Bool
    let enabledDate: Date?
    let parentQuest: String?
    let progress: String
    let xpReward: String?
    let itemReward: String?
    let image: String?
    
    init(id: String, name: String, enabled: Bool, enabledDate: Date?, parentQuest: String?, xpReward: String?, itemReward: String?, progress: String, image: String?) {
        self.id = id
        self.name = name
        self.enabled = enabled
        self.enabledDate = enabledDate
        self.parentQuest = parentQuest
        self.progress = progress
        self.xpReward = xpReward
        self.itemReward = itemReward
        self.image = image
    }
}
