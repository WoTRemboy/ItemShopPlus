//
//  BundlesModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.04.2024.
//

import Foundation

// MARK: - Bundle Item

/// The struct represents a bundle of in-game items available for purchase in the shop
struct BundleItem {
    /// A unique identifier for the `BundleItem`
    let id: String
    /// Boolean indicating whether the bundle is currently available for purchase
    let available: Bool
    /// The name of the bundle
    let name: String
    /// A short description of the bundle
    let description: String
    /// A more detailed, long description of the bundle
    let descriptionLong: String
    /// URL string for the image associated with the detailed view of the bundle
    let detailsImage: String
    /// URL string for the banner image of the bundle
    let bannerImage: String
    /// URL string for a wide-format image of the bundle
    let wideImage: String
    /// Optional date indicating when the bundle will no longer be available
    let expiryDate: Date?
    /// An array of `BundlePrice` objects, detailing the price of the bundle in various currencies
    let prices: [BundlePrice]
    /// An array of `BundleGranted` items that represent the items granted by the bundle
    let granted: [BundleGranted]
    /// The currency used for pricing (defaults to USD)
    var currency: Currency = .usd
    
    /// A placeholder instance of `BundleItem` to represent an empty or error state
    static let emptyBundle = BundleItem(id: "", available: false, name: "", description: "", descriptionLong: "", detailsImage: "", bannerImage: "", wideImage: "", expiryDate: .now, prices: [], granted: [])
}

// MARK: - Bundle Price

/// The struct defines the price of a `BundleItem` in a specific currency
struct BundlePrice {
    /// The type of currency (e.g., usd, eur)
    let type: Currency
    /// The ISO code for the currency (e.g., USD for US Dollar)
    let code: String
    /// The symbol representing the currency (e.g., $ for US Dollar)
    let symbol: String
    /// The price of the bundle in the specified currency
    let price: Double
    
    /// A placeholder instance of `BundlePrice` to represent an empty or error state
    static let emptyPrice = BundlePrice(type: .usd, code: Texts.Currency.Code.usd, symbol: Texts.Currency.Symbol.usd, price: -5)
}

// MARK: - Bundle Granted

/// The struct defines an item that is granted as part of a `BundleItem`
struct BundleGranted {
    /// The unique identifier of the granted item
    let id: String
    /// The quantity of the item that is granted
    let quantity: Int
}
