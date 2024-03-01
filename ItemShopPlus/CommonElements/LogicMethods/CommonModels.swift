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
}
