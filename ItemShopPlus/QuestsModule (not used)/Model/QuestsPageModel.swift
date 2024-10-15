//
//  QuestsPageModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import Foundation

struct QuestBundle {
    let tag: String
    let name: String
    let image: String
    let subBundles: [QuestSubBundle]
}

struct QuestSubBundle {
    let id: String
    let name: String
    let beginDate: Date?
    let endDate: Date?
    let header: String
    let quests: [Quest]
}

struct Quest {
    let id: String
    let name: String
    let description: String?
    let shortDescription: String?
    let categoryHeader: String?
    let enabled: Bool
    let enabledDate: Date?
    let parentQuest: String?
    let progress: Int
    let xpReward: Int?
    let itemReward: [QuestItem]?
}

struct QuestItem {
    let id: String
    let type: String
    let name: String
    let rarity: Rarity
    let series: String?
    let image: String
}
