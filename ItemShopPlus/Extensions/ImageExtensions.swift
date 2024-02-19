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
    }
    
    enum Quests {
        static let experience = UIImage(named: "QuestXP")
        static let bundleBackground = UIImage(named: "BundleBackground")
    }
    
    enum SplashScreen {
        static let splashScreen = UIImage(named: "SplashScreen")
    }
    
    enum ShopMain {
        static let price = UIImage(named: "VBucks")
        static let info = UIImage(systemName: "info.circle")
        static let filter = UIImage(systemName: "line.3.horizontal.decrease.circle")
        static let infoFish = UIImage(named: "InfoFish")
        static let new = UIImage(named: "NewBanner")
        static let sale = UIImage(named: "SaleBanner")
        static let pickaxe = UIImage(named: "PickaxeBanner")
        static let emote = UIImage(named: "EmoteBanner")
        static let granted = createImage(name: "1.circle.fill")
        static let pages = UIImage(systemName: "decrease.quotelevel", withConfiguration: UIImage.SymbolConfiguration(paletteColors: [.IconColors.backgroundPages ?? .orange, .white]))
    }
    
    enum ShopGranted {
        static let common = UIImage(named: "GrantedCommon")
        static let uncommon = UIImage(named: "GrantedUncommon")
        static let rare = UIImage(named: "GrantedRare")
        static let epic = UIImage(named: "GrantedEpic")
        static let legendary = UIImage(named: "GrantedLegendary")
    }
}

private func createImage(name: String) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.labelTertiary, .labelTertiary]))
    return image
}
