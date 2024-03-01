//
//  CrewModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import Foundation

struct CrewPack {
    let id: String = UUID().uuidString
    let title: String
    let items: [CrewItem]
    let battlePassTitle: String?
    let addPassTitle: String?
    let vbucks: Int = 1000
    let image: String?
    let date: String
    let price: [CrewPrice]
    
    static let emptyPack = CrewPack(title: "", items: [CrewItem](), battlePassTitle: nil, addPassTitle: nil, image: nil, date: "", price: [CrewPrice.emptyPrice])
}

struct CrewItem {
    let id: String
    let type: String
    let name: String
    let description: String?
    let rarity: Rarity?
    let image: String
    let introduction: String?
}

struct CrewPrice {
    let type: Currency
    let code: String
    let symbol: String
    let price: Double
    
    static let emptyPrice = CrewPrice(type: .usd, code: Texts.Currency.Code.usd, symbol: Texts.Currency.Symbol.usd, price: -5)
}

enum CurrencyManager {
    case get
    case save
    case delete
}
