//
//  JSONCrewParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import Foundation
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "CrewModule", category: "JSONParse")

// MARK: - Crew Pack JSON Extension

extension CrewPack {
    /// Parses a JSON object to create and return a `CrewPack` instance
    /// - Parameter sharingJSON: The JSON data to be parsed
    /// - Returns: An optional `CrewPack` instance if parsing is successful; otherwise, `nil`
    static func sharingParse(sharingJSON: Any) -> CrewPack? {
        // Extracts the necessary data from the JSON object to initialize a `CrewPack`
        guard let globalData = sharingJSON as? [String: Any],
              let pricesData = globalData["prices"] as? [[String: Any]],
              let data = globalData["currentCrew"] as? [String: Any],
              
              let descriptions = data["descriptions"] as? [String: Any],
              let title = descriptions["title"] as? String,
              let itemsData = data["rewards"] as? [[String: Any]],
              let imageData = data["images"] as? [String: Any],
              let dateString = data["date"] as? String
        else {
            logger.error("Failed to parse CrewPack sharing data")
            return nil
        }
        
        // Retrieves optional titles and image from the `descriptions` and `imageData` dictionaries
        let battlePassTitle = descriptions["battlepass"] as? String
        let addPassTitle = descriptions["vbucksTitle"] as? String
        let image = imageData["apiRender"] as? String
        
        // Parses the items data into an array of `CrewItem` objects
        let items: [CrewItem] = itemsData.compactMap { CrewItem.sharingParse(sharingJSON: $0) }
        
        // Configures the date formatter and formats the month string for display
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var month = String()
        if let currectDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM"
            month = dateFormatter.string(from: currectDate)
        }
        
        // Parses the prices data into an array of `CrewPrice` objects
        var priceArray = [CrewPrice]()
        for priceDatum in pricesData {
            guard let code = priceDatum["paymentCurrencyCode"] as? String,
                  let symbol = priceDatum["paymentCurrencySymbol"] as? String,
                  let price = priceDatum["paymentCurrencyAmountNatural"] as? Double
            else {
                logger.error("Failed to parse CrewPack price data")
                return nil
            }
            // Selects the currency type based on the currency code
            let type = SelectingMethods.selectCurrency(code: code)
            priceArray.append(CrewPrice(type: type, code: code, symbol: symbol, price: price))
        }
        
        logger.info("Successfully parsed CrewPack data")
        return CrewPack(title: title, items: items, battlePassTitle: battlePassTitle, addPassTitle: addPassTitle, image: image, date: month, price: priceArray)
    }
}

// MARK: - Crew Item JSON Extension

extension CrewItem {
    /// Parses a JSON object to create and return a `CrewItem` instance
    /// - Parameter sharingJSON: The JSON data to be parsed
    /// - Returns: An optional `CrewItem` instance if parsing is successful; otherwise, `nil`
    static func sharingParse(sharingJSON: Any) -> CrewItem? {
        // Extracts the necessary data from the JSON object to initialize a `CrewItem`
        guard let globalData = sharingJSON as? [String: Any],
              let data = globalData["item"] as? [String: Any],
              
              let id = data["id"] as? String,
              let typeData = data["type"] as? [String: Any],
              let typeID = typeData["id"] as? String,
              var type = typeData["name"] as? String,
              let name = data["name"] as? String,
              let imageData = data["images"] as? [String: Any],
              let image = imageData["icon_background"] as? String
        else {
            return nil
        }
        
        // Retrieves optional values for description and shareable image
        let description = data["description"] as? String
        let shareImage = imageData["full_background"] as? String ?? String()
                
        // Determines if the item has an associated video preview
        let video: Bool
        typeID == "outfit" ? (video = true) : (video = false)
        // Overrides the type for backpack item type
        typeID == "backpack" ? (type = Texts.ShopPage.backpack) : nil

        // Parses and extracts the `introduction` text
        var introduction = String()
        if let introductionData = data["introduction"] as? [String: Any] {
            let introductionString = introductionData["text"] as? String ?? String()
            introduction = String(introductionString.split(separator: ": ").last ?? Substring(introductionString))
        }
        
        // Parses and extracts the rarity of the item
        var rarity: Rarity?
        if let rarityData = data["rarity"] as? [String: Any] {
            rarity = SelectingMethods.selectRarity(rarityText: rarityData["id"] as? String)
        }
        
        return CrewItem(id: id, type: type, name: name, description: description, rarity: rarity, image: image, shareImage: shareImage, introduction: introduction, video: video)
    }
}
