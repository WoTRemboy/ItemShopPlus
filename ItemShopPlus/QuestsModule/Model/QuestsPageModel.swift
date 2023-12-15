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
    let startDate: Date?
    let endDate: Date?
}

struct Quest: Identifiable {
    let id: String
    let name: String
    let enabled: Bool
    let enabledDate: Date?
    let parentQuest: String?
    let progress: Int
    let image: String?
    
    init(id: String, name: String, enabled: Bool, enabledDate: Date?, parentQuest: String?, progress: Int, image: String?) {
        self.id = id
        self.name = name
        self.enabled = enabled
        self.enabledDate = enabledDate
        self.parentQuest = parentQuest
        self.progress = progress
        self.image = image
    }
}
