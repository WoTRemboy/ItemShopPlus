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
            static let shop = "Item Shop"
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
        static let main = "Fort Satellite"
        static let quests = "Quests"
        static let quest = "Quest"
        static let details = "Details"
        static let shop = "Item Shop"
    }
    
    enum Navigation {
        static let cancel = "Cancel"
        static let backToMain = "Main"
        static let backToShop = "Shop"
    }
    
    enum Season {
        static let beginDate = "2023-12-03T08:00:00.000Z"
        static let endDate = "2024-03-08T02:00:00.000Z"
    }
    
    enum ShopPage {
        static let itemName = "Item name..."
        static let itemPrice = "Item price..."
        static let bundleName = "Bundle name..."
        static let segmentName = "Segment name..."
        static let rotaionTitle = "Rotation Info"
        static let rotationInfo = "The shop refreshes every day. Check back to see what's new!"
        static let reloadShop = "It's time to update!"
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
        static let headerIdentifier = "ShopHeader"
        static let search = "Search items"
    }
    
    enum ShopGrantedCell {
        static let identifier = "ShopGrantedCollectionViewCell"
        static let footerIdentifier = "ShopGrantedCollectionReusableView"
        static let firstTime = "First time..."
        static let lastTime = "Last time..."
        static let total = "Total"
        static let price = "Bundle price..."
        static let title = "Title..."
        static let content = "Content..."
    }
    
    enum ShopGrantedParameters {
        static let descriprion = "Descriprion"
        static let series = "Series"
        static let firstTime = "First release"
        static let lastTime = "Previous release"
        static let descriptionData = "Descriprion..."
        static let seriesData = "Series..."
        static let firstTimeData = "First release..."
        static let lastTimeData = "Previous release..."
    }
    
    enum ShopSearchController {
        static let result = "Result"
        static let noResult = "No result"
    }
    
    enum noConnection {
        static let noInternet = "No connection"
        static let retry = "Please, retry later"
    }
}

