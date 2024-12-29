//
//  ImageExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit
import SwiftUI

// MARK: - UIKit image extension

extension UIImage {
    
    // MARK: - Common
    
    /// Placeholder images used for missing or unavailable content
    enum Placeholder {
        static let noImage = UIImage(named: "ImagePlaceholder")
        static let noImage3To4 = UIImage(named: "ImagePlaceholder3To4")
        static let noImage16To9 = UIImage(named: "ImagePlaceholder16To9")
        static let video = UIImage(named: "VideoBanner")
    }
    
    /// Icons used in empty view states
    enum EmptyView {
        static let stats = UIImage(systemName: "chart.xyaxis.line")
        static let favourites = UIImage(systemName: "heart")
        static let internet = UIImage(systemName: "wifi")
    }
    
    /// Icons for currency symbols used throughout the app
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
    
    /// Filter menu icons
    enum FilterMenu {
        static let filter = UIImage(systemName: "line.3.horizontal.decrease.circle")
        static let filledFilter = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")
    }
    
    // MARK: - Main Module
    
    /// Icons for the main module, including shop, battle pass
    enum MainButtons {
        static let shop = UIImage(named: "ShopIcon")
        static let battlePass = UIImage(named: "BattlePassIcon")
        static let lootDetails = UIImage(named: "LootDetailsIcon")
        static let bundles = UIImage(named: "BundlesIcon")
        static let crew = UIImage(named: "CrewIcon")
        static let map = UIImage(named: "MapIcon")
        static let stats = UIImage(named: "StatsIcon")
        static let favourites = UIImage(named: "FavouritesIcon")
        static let settings = UIImage(named: "SettingsIcon")
        static let augments = createImage(name: "square.3.layers.3d.bottom.filled")
        static let question = createImage(name: "questionmark.square.dashed")
        static let chevron = createImage(name: "chevron.right")
    }
    
    // MARK: - Opening Screens Module
    
    /// Splash Screen app logo
    enum SplashScreen {
        static let splashScreen = UIImage(named: "SplashScreen")
    }
    
    // MARK: - Shop Module
    
    /// Icons specific to the shop items
    enum ShopMain {
        static let price = UIImage(named: "VBucks")
        static let info = UIImage(systemName: "info.circle")
        static let infoFish = UIImage(named: "InfoFish")
        static let new = UIImage(named: "NewBanner")
        static let free = UIImage(named: "FreeBanner")
        static let pickaxe = UIImage(named: "PickaxeBanner")
        static let emote = UIImage(named: "EmoteBanner")
        static let granted = createImage(name: "1.circle.fill")
        static let pages = createInfoSymbol(name: "decrease.quotelevel", first: .backgroundPages, second: .white)
        static let grantedInfo = createInfoSymbol(name: "5.circle.fill", first: .white, second: .backgroundPages)
        static let pagesInfo = createInfoSymbol(name: "decrease.quotelevel", first: .backgroundPages, second: .systemBlue)
        static let favouriteFalse = createInfoSymbol(name: "heart", first: .backgroundPages, second: .white)
        static let favouriteTrue = createInfoSymbol(name: "heart.fill", first: .backgroundPages, second: .systemRed)
    }
    
    /// Icons specific to the shop granted items
    enum ShopGranted {
        static let common = UIImage(named: "GrantedCommon")
        static let uncommon = UIImage(named: "GrantedUncommon")
        static let rare = UIImage(named: "GrantedRare")
        static let epic = UIImage(named: "GrantedEpic")
        static let legendary = UIImage(named: "GrantedLegendary")
        static let mythic = UIImage(named: "GrantedMythic")
        static let exotic  = UIImage(named: "GrantedExotic")
        static let transcendent = UIImage(named: "GrantedTranscendent")
        static let share = UIImage(systemName: "square.and.arrow.up")
    }
    
    // MARK: - Battle Pass Module
    
    /// Icon for the battle pass module
    enum BattlePass {
        static let star = UIImage(named: "BattlePassStar")
    }
    
    // MARK: - Settings Module
    
    /// Icons used in the settings module
    enum Settings {
        static let app = UIImage(named: "AboutAppIcon")
        static let notifications = UIImage(named: "NotificationsSetting")
        static let appearance = UIImage(named: "AppearanceSetting")
        static let cache = UIImage(named: "CacheSetting")
        static let language = UIImage(named: "LanguageSetting")
        static let currency = UIImage(named: "CurrencySetting")
        static let developer = UIImage(named: "DeveloperSetting")
        static let designer = UIImage(named: "DesignerSetting")
        static let email = UIImage(named: "EmailSetting")
    }
    
    // MARK: - Stats Module
    
    /// Icons for the stats module
    enum Stats {
        static let newNickname = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        static let noStats = UIImage(named: "NoStats")
        static let progress = UIImage(named: "ProgressStats")
        static let global = UIImage(named: "GlobalStats")
        static let input = UIImage(named: "InputStats")
        static let history = UIImage(named: "HistoryStats")
        static let touch = UIImage(systemName: "hand.tap")
        static let gamepad = UIImage(systemName: "gamecontroller")
        static let keyboard = UIImage(systemName: "keyboard")
    }
    
    // MARK: - Quests Module
    
    /// Icons for the quests module
    enum Quests {
        static let experience = UIImage(named: "QuestXP")
        static let bundleBackground = UIImage(named: "BundleBackground")
    }
    
    // MARK: - Map Module
    
    /// Icons used in the map module
    enum MapPage {
        static let poiMenu = UIImage(systemName: "slider.horizontal.3")
        static let archiveMenu = UIImage(systemName: "clock.arrow.circlepath")
        static let poiAction = UIImage(systemName: "mappin")
        static let clearAction = UIImage(systemName: "mappin.slash")
    }
    
    // MARK: - Widget Module
    
    /// Icons for the widget module
    enum Widget {
        static let mockItem = UIImage(named: "MockItem")
    }
}

// MARK: - Main Module Button Images Color Setup

/// Creates an image with a specific system name and predefined palette colors
/// - Parameter name: The system name of the image
/// - Returns: An optional `UIImage` object with the specified configuration
private func createImage(name: String) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.labelPrimary, .labelPrimary]))
    return image
}

/// Creates a dual-color icon using a system name and custom colors
/// - Parameters:
///   - name: The system name of the image
///   - first: The primary color of the image
///   - second: The secondary color of the image
/// - Returns: An optional `UIImage` object with the specified colors
private func createInfoSymbol(name: String, first: UIColor, second: UIColor) -> UIImage? {
    let image = UIImage(
        systemName: name,
        withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [first, second]))
    return image
}


// MARK: - SwiftUI image extension

extension Image {
        
    /// Images for the onboarding screens
    enum OnboardingScreen {
        static let fort = Image("OnboardFortSatellite")
        static let play = Image("OnboardPlay")
        static let widget = Image("OnboardWidget")
        static let placeholder = Image("OnboardPlaceholder")
        static let appIcon = Image("OnboardAppIcon")
    }
        
    /// Icons for the widget module
    enum Widget {
        static let placeholder = Image("ImagePlaceholder")
        static let vBucks = Image("VBucks")
        static let newBanner = Image("NewItemBanner")
        static let appIcon = Image("AppIcon")
    }
}
