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
              let offerData = data["offerDates"] as? [String: Any],
              
              let buyAllowed = data["buyAllowed"] as? Bool,
              buyAllowed == true
        else {
            return nil
        }
        
        let asset = assetsData.first
        var image = asset?["background"] as? String ?? String()
        
        if let grantedData = data["granted"] as? [[String: Any]], let granted = grantedData.first {
            let imagesData = granted["images"] as? [String: Any]
            if let imageData = imagesData?["icon_background"] as? String {
                image = imageData
            }
        }
        
        let finalPrice = priceData["finalPrice"] as? Int ?? 0
        let regularPrice = priceData["regularPrice"] as? Int ?? 0
        
        let bannerData = data["banner"] as? [String: Any]
        let bannerName = bannerData?["id"] as? String ?? String()
        let banner = WidgetBanner.init(rawValue: bannerName) ?? .null
        
        var previousDate: Date?
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterTime.locale = Locale(identifier: "en_US_POSIX")
        
        let previousDateString = offerData["in"] as? String ?? String()
        if let date = dateFormatterTime.date(from: previousDateString) {
            previousDate = date
        }
        
        return WidgetShopItem(id: id, name: name, image: image, buyAllowed: buyAllowed, price: finalPrice, regularPrice: regularPrice, previousReleaseDate: previousDate ?? .init(timeIntervalSince1970: 0), banner: banner)
    }
}
