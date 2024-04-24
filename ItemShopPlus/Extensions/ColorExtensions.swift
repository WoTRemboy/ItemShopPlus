//
//  ColorExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

extension UIColor {
    enum BackColors {
        static let backElevated = UIColor(named: "BackElevated")
        static let backiOSPrimary = UIColor(named: "BackiOSPrimary")
        static let backPopup = UIColor(named: "BackPopup")
        static let backPrimary = UIColor(named: "BackPrimary")
        static let backPreview = UIColor(named: "BackPreview")
        static let backSecondary = UIColor(named: "BackSecondary")
        static let backSplash = UIColor(named: "BackSplash")
        static let backStats = UIColor(named: "BackStats")
        static let backDefault = UIColor(named: "BackDefault")
    }
    
    enum LabelColors {
        static let labelDisable = UIColor(named: "LabelDisable")
        static let labelPreview = UIColor(named: "LabelPreview")
        static let labelPrimary = UIColor(named: "LabelPrimary")
        static let labelSecondary = UIColor(named: "LabelSecondary")
        static let labelTertiary = UIColor(named: "LabelTertiary")
    }
    
    enum SupportColors {
        static let supportButton = UIColor(named: "SupportButton")
        static let supportNavBar = UIColor(named: "SupportNavBar")
        static let supportOverlay = UIColor(named: "SupportOverlay")
        static let supportSegmented = UIColor(named: "SupportSegmented")
        static let supportSeparator = UIColor(named: "SupportSeparator")
        static let supportTextView = UIColor(named: "SupportTextView")
    }
    
    enum QuestsBundleColors {
        static let bundleBackground = UIColor(named: "BundleImageBackground")
    }
    
    enum IconColors {
        static let foregroundPages = UIColor(named: "ForegroundPages")
        static let backgroundPages = UIColor(named: "BackgroundPages")
        static let LootItemColor = UIColor(named: "LootItemColor")
    }
    
    enum Shadows {
        static let primary = UIColor.black.cgColor
    }
}
