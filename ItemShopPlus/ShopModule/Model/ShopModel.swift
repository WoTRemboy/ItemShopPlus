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
    let images: [String]
    let firstReleaseDate: Date?
    let previousReleaseDate: Date?
    let buyAllowed: Bool
    let price: Int
    let regularPrice: Int
    let series: String?
    let rarity: String
    let granted: [GrantedItem?]
    let section: String
    
    init(id: String, name: String, description: String, type: String, images: [String], firstReleaseDate: Date?, previousReleaseDate: Date?, buyAllowed: Bool, price: Int, regularPrice: Int, series: String?, rarity: String, granted: [GrantedItem?], section: String) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.images = images
        self.firstReleaseDate = firstReleaseDate
        self.previousReleaseDate = previousReleaseDate
        self.buyAllowed = buyAllowed
        self.price = price
        self.regularPrice = regularPrice
        self.series = series
        self.rarity = rarity
        self.granted = granted
        self.section = section
    }
}

struct GrantedItem {
    let id: String
    let type: String
    let name: String
    let description: String
    let rarity: String?
    let series: String?
    let image: String
    
    init(id: String, type: String, name: String, description: String, rarity: String?, series: String?, image: String) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.rarity = rarity
        self.series = series
        self.image = image
    }
}
