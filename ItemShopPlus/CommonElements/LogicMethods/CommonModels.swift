//
//  CommonModels.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation

// MARK: - Currency

enum Currency {
    case usd
    case eur
    case gbp
    case cad
    case rub
    case dkk
    case jpy
    case sek
    case brl
    case nok
    case aud
    case lira
}

enum CurrencySymbolPosition {
    case left
    case right
}


// MARK: - Rarity

enum Rarity {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    case star
    case mythic
    case transcendent
    case exotic
    
    static func rarityToString(rarity: Rarity) -> String {
        switch rarity {
        case .common:
            return Texts.Rarity.common
        case .uncommon:
            return Texts.Rarity.uncommon
        case .rare:
            return Texts.Rarity.rare
        case .epic:
            return Texts.Rarity.epic
        case .legendary:
            return Texts.Rarity.legendary
        case .star:
            return Texts.Rarity.star
        case .mythic:
            return Texts.Rarity.mythic
        case .transcendent:
            return Texts.Rarity.transcendent
        case .exotic:
            return Texts.Rarity.exotic
        }
    }
}

// MARK: - Internal Currency Image

enum CurrencyImage {
    case vbucks
    case star
}
