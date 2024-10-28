//
//  CommonModels.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.02.2024.
//

import Foundation

// MARK: - Currency

/// Represents different types of currencies
enum Currency {
    case usd   // US Dollar
    case eur   // Euro
    case gbp   // British Pound
    case cad   // Canadian Dollar
    case rub   // Russian Ruble
    case dkk   // Danish Krone
    case jpy   // Japanese Yen
    case sek   // Swedish Krona
    case brl   // Brazilian Real
    case nok   // Norwegian Krone
    case aud   // Australian Dollar
    case lira  // Turkish Lira
}

/// Defines the position of the currency symbol relative to the amount
enum CurrencySymbolPosition {
    case left   // Symbol appears to the left of the value
    case right  // Symbol appears to the right of the value
}


// MARK: - Rarity

/// Represents different levels of rarity for items
enum Rarity {
    case common         // Common rarity
    case uncommon       // Uncommon rarity
    case rare           // Rare rarity
    case epic           // Epic rarity
    case legendary      // Legendary rarity
    case star           // Star rarity
    case mythic         // Mythic rarity
    case transcendent   // Transcendent rarity
    case exotic         // Exotic rarity
    
    /// Converts a `Rarity` enum case to its corresponding string value
    /// - Parameter rarity: The rarity to be converted
    /// - Returns: A string representing the rarity
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

/// Represents currencies used in various contexts, such as for purchasing items
enum CurrencyImage {
    case vbucks  // The primary currency in Fortnite (V-Bucks)
    case star    // Star currency, used for battle pass items
}
