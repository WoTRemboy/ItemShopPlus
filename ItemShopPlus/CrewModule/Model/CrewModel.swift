//
//  CrewModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import Foundation

// MARK: - Crew Pack

/// The struct represents a bundle that includes a set of in-game items, provided as part of a subscription service
struct CrewPack {
    /// A unique identifier for the `CrewPack`
    let id: String = UUID().uuidString
    /// The title of the Crew Pack
    let title: String
    /// An array of `CrewItem` objects that represent the items in the Crew Pack
    let items: [CrewItem]
    /// Optional title for an included Battle Pass
    let battlePassTitle: String?
    /// Optional title for an additional pass (e.g., Rocket League Pass) included in the pack
    let addPassTitle: String?
    /// The number of virtual currency (V-Bucks) included in the pack
    let vbucks: Int = 1000
    /// Optional URL string for the image associated with the Crew Pack
    let image: String?
    /// The release date of the Crew Pack
    let date: String
    /// An array of `CrewPrice` objects, detailing the price in various currencies
    let price: [CrewPrice]
    
    /// A placeholder instance of `CrewPack` to represent an empty or error state
    static let emptyPack = CrewPack(title: "", items: [CrewItem](), battlePassTitle: nil, addPassTitle: nil, image: nil, date: "", price: [CrewPrice.emptyPrice])
}

// MARK: - Crew Item

/// The struct defines an item included in a `CrewPack`
struct CrewItem {
    /// The unique identifier for the item
    let id: String
    /// The type or category of the item (e.g., outfit, glider, emote)
    let type: String
    /// The name of the item
    let name: String
    /// Optional description text for the item
    let description: String?
    /// Optional rarity of the item (e.g., common, rare, epic)
    let rarity: Rarity?
    /// URL string for the main image associated with the item
    let image: String
    /// URL string for a shareable version of the item image
    let shareImage: String
    /// Optional text introducing the item first appearance
    let introduction: String?
    /// Boolean indicating whether the item has an associated video preview
    let video: Bool
}

// MARK: - Crew Price

/// The struct defines the price of a `CrewPack` in a specific currency
struct CrewPrice {
    /// The type of currency (e.g., usd, eur)
    let type: Currency
    /// The ISO code for the currency (e.g., USD for US Dollar)
    let code: String
    /// The symbol representing the currency (e.g., $ for US Dollar)
    let symbol: String
    /// The price of the Crew Pack in the specified currency
    let price: Double
    
    /// A placeholder instance of `CrewPrice` to represent an empty or error state
    static let emptyPrice = CrewPrice(type: .usd, code: Texts.Currency.Code.usd, symbol: Texts.Currency.Symbol.usd, price: -5)
}

// MARK: - Currency Manager

/// An enum representing actions that can be performed with a currency
enum CurrencyManager {
    // Retrieve the currency data
    case get
    // Save the currency data
    case save
    // Remove the currency data
    case delete
}
