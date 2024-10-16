//
//  SelectingMethods.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation
import UIKit

/// A class that provides selection logic for banners, currencies, rarities, payment types, input types, and weapon tags
final class SelectingMethods {
    
    // MARK: - Banner
    
    /// Selects the appropriate `Banner` enum based on the given banner text
    /// - Parameter bannerText: A string representing the banner text
    /// - Returns: A `Banner` enum value
    static func selectBanner(bannerText: String?) -> Banner {
        switch bannerText {
        case "New":
            return .new
        case "vbucksoff":
            return .sale
        case "emotebuiltin":
            return .emote
        case "PickaxeIncluded":
            return .pickaxe
        default:
            return .null
        }
    }
    
    /// Selects the appropriate banner image based on the `Banner` enum value
    /// - Parameter banner: A `Banner` enum
    /// - Returns: A `UIImage?` representing the banner image
    static func selectBanner(banner: Banner) -> UIImage? {
        switch banner {
        case .new:
            return .ShopMain.new
        case .sale:
            return .ShopMain.infoFish
        case .emote:
            return .ShopMain.emote
        case .pickaxe:
            return .ShopMain.pickaxe
        case .free:
            return .ShopMain.free
        default:
            return .ShopMain.new
        }
    }
    
    // MARK: - Currency
    
    /// Selects the appropriate `Currency` enum based on the given currency code
    /// - Parameter code: A string representing the currency code
    /// - Returns: A `Currency` enum value
    static func selectCurrency(code: String?) -> Currency {
        switch code {
        case Texts.Currency.Code.eur:
            return .eur
        case Texts.Currency.Code.usd:
            return .usd
        case Texts.Currency.Code.gbp:
            return .gbp
        case Texts.Currency.Code.cad:
            return .cad
        case Texts.Currency.Code.rub:
            return .rub
        case Texts.Currency.Code.dkk:
            return .dkk
        case Texts.Currency.Code.jpy:
            return .jpy
        case Texts.Currency.Code.sek:
            return .sek
        case Texts.Currency.Code.brl:
            return .brl
        case Texts.Currency.Code.nok:
            return .nok
        case Texts.Currency.Code.aud:
            return .aud
        case Texts.Currency.Code.lira:
            return .lira
        default:
            return .usd
        }
    }
    
    /// Selects the appropriate currency symbol image based on the given currency type
    /// - Parameter type: A string representing the currency type
    /// - Returns: A `UIImage` representing the currency symbol
    static func selectCurrency(type: String?) -> UIImage {
        switch type {
        case Texts.Currency.Code.usd:
            return .CurrencySymbol.usd ?? UIImage()
        case Texts.Currency.Code.eur:
            return .CurrencySymbol.eur ?? UIImage()
        case Texts.Currency.Code.gbp:
            return .CurrencySymbol.gbp ?? UIImage()
        case Texts.Currency.Code.cad:
            return .CurrencySymbol.usd ?? UIImage()
        case Texts.Currency.Code.rub:
            return .CurrencySymbol.rub ?? UIImage()
        case Texts.Currency.Code.dkk:
            return .CurrencySymbol.dkk ?? UIImage()
        case Texts.Currency.Code.jpy:
            return .CurrencySymbol.jpy ?? UIImage()
        case Texts.Currency.Code.sek:
            return .CurrencySymbol.sek ?? UIImage()
        case Texts.Currency.Code.brl:
            return .CurrencySymbol.brl ?? UIImage()
        case Texts.Currency.Code.nok:
            return .CurrencySymbol.nok ?? UIImage()
        case Texts.Currency.Code.aud:
            return .CurrencySymbol.aud ?? UIImage()
        case Texts.Currency.Code.lira:
            return .CurrencySymbol.lira ?? UIImage()
        default:
            return UIImage()
        }
    }
    
    /// Selects the appropriate currency symbol position based on the `Currency` enum
    /// - Parameter type: A `Currency` enum value
    /// - Returns: A `CurrencySymbolPosition` enum value
    static func selectCurrencyPosition(type: Currency) -> CurrencySymbolPosition {
        switch type {
        case .usd, .eur, .gbp, .cad, .brl, .nok, .aud, .jpy:
            return .left
        case .rub, .dkk, .sek, .lira:
            return .right
        }
    }
    
    // MARK: - Rarity
    
    /// Selects the appropriate `Rarity` enum based on the given rarity text
    /// - Parameter rarityText: A string representing the rarity
    /// - Returns: A `Rarity` enum value
    static func selectRarity(rarityText: String?) -> Rarity {
        switch rarityText {
        case "Common", "common":
            return .common
        case "Uncommon", "uncommon":
            return .uncommon
        case "Rare", "rare":
            return .rare
        case "Epic", "epic":
            return .epic
        case "Legendary", "legendary":
            return .legendary
        case "Mythic", "mythic":
            return .mythic
        case "Transcendent", "transcendent":
            return .transcendent
        case "Exotic", "exotic":
            return .exotic
        default:
            return .common
        }
    }
    
    /// Selects the appropriate rarity image based on the `Rarity` enum
    /// - Parameter rarity: A `Rarity` enum
    /// - Returns: A `UIImage` representing the rarity
    static func selectRarity(rarity: Rarity) -> UIImage {
        switch rarity {
        case .common:
            return .ShopGranted.common ?? .grantedCommon
        case .uncommon:
            return .ShopGranted.uncommon ?? .grantedUncommon
        case .rare:
            return .ShopGranted.rare ?? .grantedRare
        case .epic:
            return .ShopGranted.epic ?? .grantedEpic
        case .legendary:
            return .ShopGranted.legendary ?? .grantedLegendary
        case .star:
            return .BattlePass.star ?? .battlePassStar
        case .mythic:
            return .ShopGranted.mythic ?? .grantedMythic
        case .transcendent:
            return .ShopGranted.transcendent ?? .grantedTranscendent
        case .exotic:
            return .ShopGranted.exotic ?? .grantedExotic
        }
    }
    
    // MARK: - Rarity
    
    /// Selects the appropriate `PayType` enum based on the given string
    /// - Parameter payType: A string representing the pay type
    /// - Returns: A `PayType` enum value
    static func selectPayType(payType: String) -> PayType {
        switch payType {
        case "free":
            return .free
        case "paid":
            return .paid
        default:
            return .paid
        }
    }
    
    /// Converts the `PayType` enum into a string representation
    /// - Parameter payType: A `PayType` enum value
    /// - Returns: A string representing the pay type
    static func selectPayType(payType: PayType) -> String {
        switch payType {
        case .free:
            return Texts.BattlePassPage.free
        case .paid:
            return Texts.BattlePassPage.paid
        }
    }
    
    // MARK: - Input
    
    /// Selects the appropriate input type image based on the given type
    /// - Parameter type: A string representing the input type
    /// - Returns: A `UIImage` representing the input type
    static func selectInput(type: String?) -> UIImage {
        switch type {
        case "touch":
            return .Stats.touch ?? UIImage()
        case "keyboardmouse":
            return .Stats.keyboard ?? UIImage()
        case "gamepad":
            return .Stats.gamepad ?? UIImage()
        default:
            return UIImage()
        }
    }
    
    /// Converts the input type into a string representation
    /// - Parameter type: A string representing the input type
    /// - Returns: A string representing the input type
    static func selectInput(type: String?) -> String {
        switch type {
        case "touch":
            return Texts.StatsDetailsPage.touch
        case "keyboardmouse":
            return Texts.StatsDetailsPage.keyboard
        case "gamepad":
            return Texts.StatsDetailsPage.gamepad
        default:
            return String()
        }
    }
    
    /// Converts the party type into a string representation
    /// - Parameter type: A string representing the party type
    /// - Returns: A string representing the party type
    static func selectPartyType(type: String) -> String {
        switch type {
        case "solo":
            return Texts.StatsDetailsPage.solo
        case "duo":
            return Texts.StatsDetailsPage.duo
        case "trio":
            return Texts.StatsDetailsPage.trio
        case "squad":
            return Texts.StatsDetailsPage.squad
        default:
            return Texts.StatsDetailsPage.solo
        }
    }
    
    // MARK: - Armory
    
    /// Converts the weapon tag into a string representation
    /// - Parameter tag: A string representing the weapon tag
    /// - Returns: A string representing the weapon type
    static func selectWeaponTag(tag: String) -> String {
        switch tag {
        case "Pistols":
            return Texts.LootDetailsStats.pistols
        case "Assault":
            return Texts.LootDetailsStats.assault
        case "Shotgun":
            return Texts.LootDetailsStats.shotgun
        case "Sniper":
            return Texts.LootDetailsStats.sniper
        case "Bow":
            return Texts.LootDetailsStats.bow
        case "Blade":
            return Texts.LootDetailsStats.blade
        case "Launcher":
            return Texts.LootDetailsStats.launcher
        case "Gadget":
            return Texts.LootDetailsStats.gadget
        case "Heal":
            return Texts.LootDetailsStats.heal
        case "Misc":
            return Texts.LootDetailsStats.misc
        default:
            return Texts.ShopPage.allMenu
        }
    }
}
