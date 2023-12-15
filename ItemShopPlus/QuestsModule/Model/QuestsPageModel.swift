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
    let taskText: String
    let importance: String
    let deadline: Date
    let pictureURL: String
    
    init(id: String, taskText: String, importance: String, deadline: Date, pictureURL: String) {
        self.id = id
        self.taskText = taskText
        self.importance = importance
        self.deadline = deadline
        self.pictureURL = pictureURL
    }
}
