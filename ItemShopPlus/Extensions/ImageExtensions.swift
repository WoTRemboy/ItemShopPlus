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
        static let shop = createImage(name: "basket")
        static let battlePass = createImage(name: "star")
        static let tournaments = createImage(name: "medal")
        static let quests = createImage(name: "list.bullet.clipboard")
        static let crew = createImage(name: "waveform")
        static let map = createImage(name: "map")
        static let vehicles = createImage(name: "car")
        static let augments = createImage(name: "square.3.layers.3d.bottom.filled")
        
//        static let shop = UIImage(named: "Shop")
//        static let news = UIImage(named: "News")
//        static let tournaments = UIImage(named: "Tournaments")
//        static let quests = UIImage(named: "Quests")
    }
    
    enum Quests {
        static let experience = UIImage(named: "QuestXP")
        static let bundleBackground = UIImage(named: "BundleBackground")
    }
    
    enum SplashScreen {
        static let splashScreen = UIImage(named: "SplashScreen")
    }
}

private func createImage(name: String) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.labelTertiary, .labelTertiary]))
    return image
}
