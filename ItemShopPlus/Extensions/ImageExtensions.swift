//
//  ImageExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIImage {
    enum Placeholder {
        static let noImage = UIImage(named: "ImagePlaceholder")
    }
    
    enum MainButtons {
        static let shop = UIImage(named: "Shop")
        static let news = UIImage(named: "News")
        static let tournaments = UIImage(named: "Tournaments")
        static let quests = UIImage(named: "Quests")
    }
    
    enum Quests {
        static let experience = UIImage(named: "QuestXP")
    }
}
