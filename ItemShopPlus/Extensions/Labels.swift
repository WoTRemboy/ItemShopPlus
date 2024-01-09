//
//  Labels.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class Texts {
    enum Placeholder {
        static let noText = "Something wrong..."
    }
    
    enum ButtonLabels {
        enum MainButtons {
            static let shop = "Daily Shop"
            static let quests = "Quests"
            static let battlePass = "Battle Pass"
            static let tournaments = "Tournaments"
            static let crew = "Crew"
            static let map = "Map"
            static let vehicles = "Vehicles"
            static let augments = "Augments"
        }
    }
    
    enum Pages {
        static let main = "Item Shop Plus"
        static let quests = "Quests"
        static let quest = "Quest"
        static let details = "Details"
        static let shop = "Item Shop"
    }
    
    enum Navigation {
        static let cancel = "Cancel"
        static let backToMain = "Main"
    }
    
    enum Season {
        static let beginDate = "2023-12-03T08:00:00.000Z"
        static let endDate = "2024-03-08T02:00:00.000Z"
    }
    
    enum ShopPage {
        static let itemName = "Item name..."
        static let itemPrice = "Item price..."
    }
    
    enum BundleQuestsCell {
        static let identifier = "BundleCell"
        static let bundleName = "Bundle name..."
        static let bundleDate = "Until the end of this season"
    }
    
    enum QuestCell {
        static let identifier = "QuestCell"
        static let questName = "Task name..."
        static let questProgress = "Quest progress..."
        static let requirement = "Requirement: "
    }
    
    enum QuestDetails {
        static let rewards = "Rewards: "
        static let reward = "Reward: "
        static let xp = " XP"
        static let requirement = "Requirement: "
    }
    
    enum ShopMainCell {
        static let identifier = "ShopCollectionViewCell"
        static let vBucks = " VBucks"
    }
}

