//
//  BundlesModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.04.2024.
//

import Foundation

struct BundleItem {
    let id: String
    let available: Bool
    let name: String
    let description: String
    let descriptionLong: String
    let detailsImage: String
    let wideImage: String
    let expiryDate: Date?
    let prices: [BundlePrice]
    let granted: [BundleGranted]
    var currency: Currency = .usd
    
    static let emptyBundle = BundleItem(id: "", available: false, name: "", description: "", descriptionLong: "", detailsImage: "", wideImage: "", expiryDate: .now, prices: [], granted: [])
}

struct BundlePrice {
    let type: Currency
    let code: String
    let symbol: String
    let price: Double
    
    static let emptyPrice = BundlePrice(type: .usd, code: Texts.Currency.Code.usd, symbol: Texts.Currency.Symbol.usd, price: -5)
}

struct BundleGranted {
    let id: String
    let quantity: Int
}
