//
//  ShopModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import Foundation

struct ShopModel {
    let id: String
    let name: String
    let description: String
    let type: String
    let image: String
    let firstReleaseDate: Date?
    let previousReleaseDate: Date?
    let buyAllowed: Bool
    let price: Int
    let rarity: String
    
    init(id: String, name: String, description: String, type: String, image: String, firstReleaseDate: Date?, previousReleaseDate: Date?, buyAllowed: Bool, price: Int, rarity: String) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.image = image
        self.firstReleaseDate = firstReleaseDate
        self.previousReleaseDate = previousReleaseDate
        self.buyAllowed = buyAllowed
        self.price = price
        self.rarity = rarity
    }
}
