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
    let price: [String: (String, Double)]?
}

struct CrewItem {
    let id: String
    let type: String
    let name: String
    let description: String?
    let rarity: String?
    let image: String
    let introduction: String?
}
