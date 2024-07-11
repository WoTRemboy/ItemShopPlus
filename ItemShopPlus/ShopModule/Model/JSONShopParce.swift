//
//  JSONShopParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.01.2024.
//

import Foundation

extension ShopItem {
    static func sharingParse(sharingJSON: Any) -> ShopItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["mainId"] as? String,
              let name = data["displayName"] as? String,
              let description = data["displayDescription"] as? String,
              let type = data["displayType"] as? String,
              
              let assetsData = data["displayAssets"] as? [[String: Any]],
              let priceData = data["price"] as? [String: Any],
              let offerData = data["offerDates"] as? [String: Any],
              let sectionsData = data["section"] as? [String: Any],
              
              let buyAllowed = data["buyAllowed"] as? Bool,
              buyAllowed == true
        else {
            return nil
        }
        
        var images = [ShopItemImage]()
        for asset in assetsData {
            let mode = asset["productTag"] as? String ?? String()
            let image = asset["background"] as? String ?? String()
            if mode != "MAX" {
                images.append(ShopItemImage(mode: mode, image: image))
            }
        }
        let sortOrder = ["Product.BR", "Product.Juno", "Product.DelMar"]
        images.sort(by: {
            guard let first = sortOrder.firstIndex(of: $0.mode),
                  let second = sortOrder.firstIndex(of: $1.mode) else {
                return false
            }
            return first < second
        })
        
        if images.isEmpty {
            for asset in assetsData {
                let mode = asset["primaryMode"] as? String ?? String()
                let image = asset["background"] as? String ?? String()
                images.append(ShopItemImage(mode: mode, image: image))
            }
        }
        
        let finalPrice = priceData["finalPrice"] as? Int ?? 0
        let regularPrice = priceData["regularPrice"] as? Int ?? 0
        
        let rarityData = data["rarity"] as? [String: Any]
        let rarity = SelectingMethods.selectRarity(rarityText: rarityData?["id"] as? String)
        let section = sectionsData["name"] as? String ?? String()
        
        let seriesData = data["series"] as? [String: Any]
        let series = seriesData?["name"] as? String
        
        var firstDate: Date?
        var previousDate: Date?
        var expiryDate: Date?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatterTime.locale = Locale(identifier: "en_US_POSIX")
        
        let firstDateString = data["firstReleaseDate"] as? String ?? String()
        let previousDateString = offerData["in"] as? String ?? String()
        let expiryDateString = offerData["out"] as? String ?? String()
        
        if let date1 = dateFormatter.date(from: firstDateString),
           let date2 = dateFormatterTime.date(from: previousDateString),
           let date3 = dateFormatterTime.date(from: expiryDateString) {
            firstDate = date1
            previousDate = date2
            expiryDate = date3
        }
        
        let bannerData = data["banner"] as? [String: Any]
        let bannerName = bannerData?["id"] as? String
        let banner = SelectingMethods.selectBanner(bannerText: bannerName)
        
        var granted = [GrantedItem]()
        if let grantedData = data["granted"] as? [[String: Any]] {
            granted = grantedData.compactMap { GrantedItem.sharingParce(sharingJSON: $0) }
        }
        
        var video = false
        if regularPrice == finalPrice && granted.contains(where: { ($0.video != nil) }) {
            video = true
        }
        
        return ShopItem(id: id, name: name, description: description, type: type, images: images, firstReleaseDate: firstDate, previousReleaseDate: previousDate, expiryDate: expiryDate, buyAllowed: buyAllowed, price: finalPrice, regularPrice: regularPrice, series: series, rarity: rarity, granted: granted, section: section, banner: banner, video: video)
    }
}


extension GrantedItem {
    static func sharingParce(sharingJSON: Any) -> GrantedItem? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              
              let rarityData = data["rarity"] as? [String: Any],
              let typeData = data["type"] as? [String: Any],
              let imagesData = data["images"] as? [String: Any]
        else {
            return nil
        }
        
        let type: String
        let typeID = typeData["id"] as? String ?? String()
        if typeID == "backpack" {
            type = Texts.ShopPage.backpack
        } else {
            type = typeData["name"] as? String ?? String()
        }
        let series = data["series"] as? String
        let rarity: Rarity? = SelectingMethods.selectRarity(rarityText: rarityData["id"] as? String)
        
        let video = data["video"] as? String
        
        var image = String()
        if let imageData = imagesData["background"] as? String {
            image = imageData
        }

        return GrantedItem(id: id, typeID: typeID, type: type, name: name, description: description, rarity: rarity, series: series, image: image, video: video)
    }
}
