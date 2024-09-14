//
//  WidgetShopItemParse.swift
//  ItemShopPlusWidgetExtension
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation

extension WidgetShopItem {
    static func sharingParse(sharingJSON: Any) -> WidgetShopItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["mainId"] as? String,
              let name = data["displayName"] as? String,
              
              let assetsData = data["displayAssets"] as? [[String: Any]],
              let priceData = data["price"] as? [String: Any],
              
              let buyAllowed = data["buyAllowed"] as? Bool,
              buyAllowed == true
        else {
            return nil
        }
        
        
        let asset = assetsData.first
        let image = asset?["background"] as? String ?? String()
        
        let finalPrice = priceData["finalPrice"] as? Int ?? 0
        let regularPrice = priceData["regularPrice"] as? Int ?? 0
        
        let bannerData = data["banner"] as? [String: Any]
        let bannerName = bannerData?["id"] as? String ?? String()
        let banner = WidgetBanner.init(rawValue: bannerName) ?? .null
        
        return WidgetShopItem(id: id, name: name, image: image, buyAllowed: buyAllowed, price: finalPrice, regularPrice: regularPrice, banner: banner)
    }
}
