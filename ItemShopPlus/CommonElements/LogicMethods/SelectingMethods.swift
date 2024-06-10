//
//  SelectingMethods.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation
import UIKit

final class SelectingMethods {
    
    // MARK: - Banner
    
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
    
    static func selectCurrencyPosition(type: Currency) -> CurrencySymbolPosition {
        switch type {
        case .usd, .eur, .gbp, .cad, .brl, .nok, .aud, .jpy:
            return .left
        case .rub, .dkk, .sek, .lira:
            return .right
        }
    }
    
    // MARK: - Rarity
    
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
    
    static func selectPayType(payType: PayType) -> String {
        switch payType {
        case .free:
            return Texts.BattlePassPage.free
        case .paid:
            return Texts.BattlePassPage.paid
        }
    }
    
    // MARK: - Input
    
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
        case "Blade":
            return Texts.LootDetailsStats.blade
        case "Bow":
            return Texts.LootDetailsStats.bow
        case "Launcher":
            return Texts.LootDetailsStats.launcher
        default:
            return Texts.ShopPage.allMenu
        }
    }
}
