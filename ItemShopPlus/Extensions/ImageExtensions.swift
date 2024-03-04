//
//  ImageExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIImage {
    
    // MARK: - Common
    
    enum Placeholder {
        static let noImage = UIImage(named: "ImagePlaceholder")
    }
    
    enum CurrencySymbol {
        static let usd = UIImage(systemName: "dollarsign")
        static let eur = UIImage(systemName: "eurosign")
        static let gbp = UIImage(systemName: "sterlingsign")
        static let rub = UIImage(systemName: "rublesign")
        static let dkk = UIImage(systemName: "danishkronesign")
        static let jpy = UIImage(systemName: "chineseyuanrenminbisign")
        static let sek = UIImage(systemName: "swedishkronasign")
        static let brl = UIImage(systemName: "brazilianrealsign")
        static let nok = UIImage(systemName: "norwegiankronesign")
        static let aud = UIImage(systemName: "dollarsign")
        static let lira = UIImage(systemName: "turkishlirasign")
        static let unknown = UIImage(systemName: "banknote")
    }
    
    enum FilterMenu {
        static let filter = UIImage(systemName: "line.3.horizontal.decrease.circle")
        static let filledFilter = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
    }
    
    // MARK: - Main Module
    
    enum MainButtons {
        static let shop = createImage(name: "basket")
        static let battlePass = createImage(name: "star")
        static let tournaments = createImage(name: "medal")
        static let quests = createImage(name: "list.bullet.clipboard")
        static let crew = createImage(name: "pencil.and.outline")
        static let map = createImage(name: "map")
        static let stats = createImage(name: "person")
        static let augments = createImage(name: "square.3.layers.3d.bottom.filled")
        static let question = createImage(name: "questionmark.square.dashed")
        static let trash = createImage(name: "trash")
    }
    
    // MARK: - Splash Module
    
    enum SplashScreen {
        static let splashScreen = UIImage(named: "SplashScreen")
    }
    
    // MARK: - Shop Module
    
    enum ShopMain {
        static let price = UIImage(named: "VBucks")
        static let info = UIImage(systemName: "info.circle")
        static let infoFish = UIImage(named: "InfoFish")
        static let new = UIImage(named: "NewBanner")
        static let sale = UIImage(named: "SaleBanner")
        static let pickaxe = UIImage(named: "PickaxeBanner")
        static let emote = UIImage(named: "EmoteBanner")
        static let granted = createImage(name: "1.circle.fill")
        static let pages = createInfoSymbol(name: "decrease.quotelevel", first: .backgroundPages, second: .white)
        static let grantedInfo = createInfoSymbol(name: "5.circle.fill", first: .white, second: .backgroundPages)
        static let pagesInfo = createInfoSymbol(name: "decrease.quotelevel", first: .backgroundPages, second: .systemBlue)
    }
    
    enum ShopGranted {
        static let common = UIImage(named: "GrantedCommon")
        static let uncommon = UIImage(named: "GrantedUncommon")
        static let rare = UIImage(named: "GrantedRare")
        static let epic = UIImage(named: "GrantedEpic")
        static let legendary = UIImage(named: "GrantedLegendary")
    }
    
    // MARK: - Battle Pass Module
    
    enum BattlePass {
        static let star = UIImage(named: "BattlePassStar")
    }
    
    // MARK: - Quests Module
    
    enum Quests {
        static let experience = UIImage(named: "QuestXP")
        static let bundleBackground = UIImage(named: "BundleBackground")
    }
    
    // MARK: - Map Module

    enum MapPage {
        static let poiMenu = UIImage(systemName: "slider.horizontal.3")
        static let archiveMenu = UIImage(systemName: "clock.arrow.circlepath")
        static let poiAction = UIImage(systemName: "mappin")
        static let clearAction = UIImage(systemName: "mappin.slash")
    }
}

// MARK: - Main Module Button Images Color Setup

private func createImage(name: String) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.labelTertiary, .labelTertiary]))
    return image
}

private func createInfoSymbol(name: String, first: UIColor, second: UIColor) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [first, second]))
    return image
}
