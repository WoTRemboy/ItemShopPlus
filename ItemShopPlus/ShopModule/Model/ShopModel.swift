//
//  ShopModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import Foundation

struct ShopItem {
    let id: String
    let name: String
    let description: String
    let type: String
    let images: [ShopItemImage]
    let firstReleaseDate: Date?
    let previousReleaseDate: Date?
    let expiryDate: Date?
    let buyAllowed: Bool
    let price: Int
    let regularPrice: Int
    let series: String?
    let rarity: Rarity
    let granted: [GrantedItem?]
    let section: String
    let banner: Banner
    let video: Bool
    var isFavourite: Bool = false
    
    static let emptyShopItem = ShopItem(id: "", name: "", description: "", type: "", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil,  buyAllowed: false, price: 0, regularPrice: 0, series: "", rarity: .common, granted: [], section: "", banner: .null, video: false)
    
    mutating func favouriteToggle() {
        isFavourite.toggle()
    }
}

struct GrantedItem {
    let id: String
    let typeID: String
    let type: String
    let name: String
    let description: String
    let rarity: Rarity?
    let series: String?
    let image: String
    let video: String?
}

struct ShopItemImage {
    let mode: String
    let image: String
}

enum Banner {
    case null
    case new
    case sale
    case free
    case emote
    case pickaxe
}
