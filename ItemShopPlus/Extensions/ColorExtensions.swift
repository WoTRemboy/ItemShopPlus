//
//  ColorExtensions.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit
import SwiftUI

// MARK: - UIKit UIColor Extension

extension UIColor {
    
    /// A collection of background colors used for various UI elements
    enum BackColors {
        static let backElevated = UIColor(named: "BackElevated")
        static let backiOSPrimary = UIColor(named: "BackiOSPrimary")
        static let backNotification = UIColor(named: "BackNotification")
        static let backPopup = UIColor(named: "BackPopup")
        static let backPrimary = UIColor(named: "BackPrimary")
        static let backPreview = UIColor(named: "BackPreview")
        static let backSecondary = UIColor(named: "BackSecondary")
        static let backSplash = UIColor(named: "BackSplash")
        static let backStats = UIColor(named: "BackStats")
        static let backDefault = UIColor(named: "BackDefault")
        static let backTable = UIColor(named: "BackTable")
    }
    
    /// A collection of label colors for text and informational elements
    enum LabelColors {
        static let labelDisable = UIColor(named: "LabelDisable")
        static let labelNotification = UIColor(named: "LabelNotification")
        static let labelPreview = UIColor(named: "LabelPreview")
        static let labelPrimary = UIColor(named: "LabelPrimary")
        static let labelSecondary = UIColor(named: "LabelSecondary")
        static let labelTertiary = UIColor(named: "LabelTertiary")
    }
    
    /// A collection of support colors for buttons, separators, navigation bars, and overlays
    enum SupportColors {
        static let supportButton = UIColor(named: "SupportButton")
        static let supportNavBar = UIColor(named: "SupportNavBar")
        static let supportOverlay = UIColor(named: "SupportOverlay")
        static let supportSegmented = UIColor(named: "SupportSegmented")
        static let supportSeparator = UIColor(named: "SupportSeparator")
        static let supportTextView = UIColor(named: "SupportTextView")
    }
    
    /// A collection of colors related to quest bundles
    enum QuestsBundleColors {
        static let bundleBackground = UIColor(named: "BundleImageBackground")
    }
    
    /// Colors for icons used across the app
    enum IconColors {
        static let foregroundPages = UIColor(named: "ForegroundPages")
        static let backgroundPages = UIColor(named: "BackgroundPages")
        static let LootItemColor = UIColor(named: "LootItemColor")
    }
    
    /// A collection of shadow colors used in the app
    enum Shadows {
        static let primary = UIColor.black.cgColor
    }
}

// MARK: - SwiftUI Color Extension

extension Color {
    
    /// Colors used in the onboarding screen in SwiftUI
    enum OnboardingScreen {
        static let orange = Color("BackgroundOrange")
        static let green = Color("BackgroundGreen")
    }
    
    /// Colors used for widgets
    enum Widget {
        static let placeholder = Color("WidgetPlaceholder")
    }
}
