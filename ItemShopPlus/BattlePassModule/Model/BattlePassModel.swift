//
//  BattlePassModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.03.2024.
//

import Foundation

struct BattlePass {
    let id: Int
    let chapter: String
    let season: String
    let passName: String
    let beginDate: Date
    let endDate: Date
    let video: String?
    let items: [BattlePassItem]
    
    static let emptyPass = BattlePass(id: 0, chapter: "Chapter X", season: "Season X", passName: "Error Pass", beginDate: .now, endDate: .now, video: nil, items: [BattlePassItem.emptyItem])
}

struct BattlePassItem {
    let id: String
    let tier: Int
    let page: Int
    let payType: String
    let price: Int
    let rewardWall: Int
    let levelWall: Int
    
    let type: String
    let name: String
    let description: String
    let rarity: Rarity
    let series: String?
    let releaseDate: Date
    let image: String
    let introduction: String
    let set: String
    
    static let emptyItem = BattlePassItem(id: "", tier: 0, page: 0, payType: "", price: 0, rewardWall: 0, levelWall: 0, type: "", name: "", description: "", rarity: .common, series: nil, releaseDate: .now, image: "", introduction: "", set: "")
}
