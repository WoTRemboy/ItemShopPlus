//
//  JSONCrewParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import Foundation

extension CrewPack {
    static func sharingParse(sharingJSON: Any) -> CrewPack? {
        guard let globalData = sharingJSON as? [String: Any],
              let pricesData = globalData["prices"] as? [[String: Any]],
              let data = globalData["currentCrew"] as? [String: Any],
              let descriptions = data["descriptions"] as? [String: Any],
              let title = descriptions["title"] as? String,
              let itemsData = data["rewards"] as? [[String: Any]],
              let imageData = data["images"] as? [String: Any],
              let dateString = data["date"] as? String
        else {
            return nil
        }
        
        let battlePassTitle = descriptions["battlepass"] as? String
        let addPassTitle = descriptions["vbucksTitle"] as? String
        let image = imageData["apiRender"] as? String
        
        let items: [CrewItem] = itemsData.compactMap { CrewItem.sharingParse(sharingJSON: $0) }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var month = String()
        if let currectDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM"
            month = dateFormatter.string(from: currectDate)
        }
        
        var priceDictionary = [String: (String, Double)]()
        for priceDatum in pricesData {
            guard let price = priceDatum["paymentCurrencyCode"] as? String,
                  let symbol = priceDatum["paymentCurrencySymbol"] as? String,
                  let amount = priceDatum["paymentCurrencyAmountNatural"] as? Double
            else {
                return nil
            }
            priceDictionary[price] = (symbol, amount)
        }
        
        return CrewPack(title: title, items: items, battlePassTitle: battlePassTitle, addPassTitle: addPassTitle, image: image, date: month, price: priceDictionary)
    }
}

extension CrewItem {
    static func sharingParse(sharingJSON: Any) -> CrewItem? {
        guard let globalData = sharingJSON as? [String: Any],
              let data = globalData["item"] as? [String: Any],
              
              let id = data["id"] as? String,
              let typeData = data["type"] as? [String: Any],
              let type = typeData["name"] as? String,
              let name = data["name"] as? String,
              let imageData = data["images"] as? [String: Any],
              let image = imageData["icon_background"] as? String
        else {
            return nil
        }
        
        let description = data["description"] as? String

        var introduction = String()
        if let introductionData = data["introduction"] as? [String: Any] {
            introduction = introductionData["text"] as? String ?? String()
        }
        
        var rarity = String()
        if let rarityData = data["rarity"] as? [String: Any] {
            rarity = rarityData["id"] as? String ?? String()
        }
        
        return CrewItem(id: id, type: type, name: name, description: description, rarity: rarity, image: image, introduction: introduction)
    }
}
