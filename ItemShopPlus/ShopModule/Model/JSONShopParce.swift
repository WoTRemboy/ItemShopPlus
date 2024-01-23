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
              let rarityData = data["rarity"] as? [String: Any],
              let sectionsData = data["section"] as? [String: Any],
              let grantedData = data["granted"] as? [[String: Any]],
              
              let buyAllowed = data["buyAllowed"] as? Bool,
              buyAllowed == true
        else {
            return nil
        }
        
        var images = [String]()
        var firstDate: Date?
        var previousDate: Date?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for asset in assetsData {
            let image = asset["background"] as? String ?? ""
            images.append(image)
        }
        
        let finalPrice = priceData["finalPrice"] as? Int ?? 0
        let regularPrice = priceData["regularPrice"] as? Int ?? 0
        let rarity = rarityData["name"] as? String ?? ""
        let section = sectionsData["name"] as? String ?? ""
        
        let seriesData = data["series"] as? [String: Any]
        let series = seriesData?["name"] as? String
        
        let firstDateString = data["firstReleaseDate"] as? String ?? ""
        let previousDateString = data["previousReleaseDate"] as? String ?? ""
        if let date1 = dateFormatter.date(from: firstDateString), let date2 = dateFormatter.date(from: previousDateString) {
            firstDate = date1
            previousDate = date2
        }
        
        let granted: [GrantedItem] = grantedData.compactMap { GrantedItem.sharingParce(sharingJSON: $0) }
        
        return ShopItem(id: id, name: name, description: description, type: type, images: images, firstReleaseDate: firstDate, previousReleaseDate: previousDate, buyAllowed: buyAllowed, price: finalPrice, regularPrice: regularPrice, series: series, rarity: rarity, granted: granted, section: section)
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
        
        var type = typeData["id"] as? String ?? ""
        type = capitalizeFirstLetter(input: type)
        
        let rarity = rarityData["id"] as? String
        let series = data["series"] as? String
        
        var image = ""
        if let imageData = imagesData["background"] as? String {
            image = imageData
        }
        
        return GrantedItem(id: id, type: type, name: name, description: description, rarity: rarity, series: series, image: image)
    }
}

private func capitalizeFirstLetter(input: String) -> String {
    var capitalizedWords = [String]()

    let dirtyWords = input.replacingOccurrences(of: "_", with: " ")
    let words = dirtyWords.components(separatedBy: " ")
    
    for word in words {
        if let firstLetter = word.first {
            let capitalizedWord = String(firstLetter).uppercased() + String(word.dropFirst())
            capitalizedWords.append(capitalizedWord)
        }
    }

    let result = capitalizedWords.joined(separator: " ")
    return result
}
