//
//  JSONBattlePassParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.03.2024.
//

import Foundation
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "BattlePassModule", category: "JSONParse")

// MARK: - BattlePass JSON Parsing Extension

extension BattlePass {
    /// Parses a `BattlePass` instance from a JSON object
    /// - Parameter sharingJSON: The JSON data to parse
    /// - Returns: An optional `BattlePass` instance if parsing is successful, otherwise `nil`
    static func sharingParse(sharingJSON: Any) -> BattlePass? {
        // Unwrapping the required fields from the JSON data
        guard let globalData = sharingJSON as? [String: Any],
              let displayData = globalData["displayInfo"] as? [String: Any],
              let seasonsData = globalData["seasonDates"] as? [String: Any],
              let videoData = globalData["videos"] as? [[String: Any]],
              let itemsData = globalData["rewards"] as? [[String: Any]],
                
              let id = globalData["season"] as? Int,
              let chapter = displayData["chapter"] as? String,
              let season = displayData["chapterSeason"] as? String,
              let passName = displayData["battlepassName"] as? String,
              
              let beginDateString = seasonsData["begin"] as? String,
              let endDateString = seasonsData["end"] as? String
        else {
            logger.error("Failed to parse BattlePass item sharing data")
            return nil
        }
        
        // Extracting the video URL
        let video = videoData.first?["url"] as? String
        // Parsing Battle Pass items from the nested JSON array
        let items: [BattlePassItem] = itemsData.compactMap { BattlePassItem.sharingParse(sharingJSON: $0) }
        
        // Parsing date strings to Date objects using a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let beginDate = dateFormatter.date(from: beginDateString) ?? .now
        let endDate = dateFormatter.date(from: endDateString) ?? .now
        
        return BattlePass(id: id, chapter: chapter, season: season, passName: passName, beginDate: beginDate, endDate: endDate, video: video, items: items)
    }
}

// MARK: - BattlePassItem JSON Parsing Extension

extension BattlePassItem {
    /// Parses a `BattlePassItem` instance from a JSON object
    /// - Parameter sharingJSON: The JSON data to parse
    /// - Returns: An optional `BattlePassItem` instance if parsing is successful, otherwise `nil`
    static func sharingParse(sharingJSON: Any) -> BattlePassItem? {
        // Unwrapping the required fields from the JSON data
        guard let data = sharingJSON as? [String: Any],
              let id = data["offerId"] as? String,
              let tier = data["tier"] as? Int,
              let page = data["page"] as? Int,
              let payTypeString = data["battlepass"] as? String,
              let rewardWall = data["rewardsNeededForUnlock"] as? Int,
              let levelWall = data["levelsNeededForUnlock"] as? Int,
              
              let priceData = data["price"] as? [String: Any],
              let price = priceData["amount"] as? Int,
             
              let itemData = data["item"] as? [String: Any],
              let name = itemData["name"] as? String,
              
              let typeData = itemData["type"] as? [String: Any],
              let type = typeData["name"] as? String,
              
              let rarityData = itemData["rarity"] as? [String: Any],
              
              let dateData = itemData["added"] as? [String: Any],
              let releaseDateString = dateData["date"] as? String,
              
              let imageData = itemData["images"] as? [String: Any],
              let image = imageData["icon_background"] as? String
        else {
            return nil
        }
        
        // Extracting optional fields from the JSON data
        let shareImage = imageData["full_background"] as? String ?? String()
        let video = itemData["video"] as? String
        let description = itemData["description"] as? String ?? ""
        let rarity = SelectingMethods.selectRarity(rarityText: rarityData["id"] as? String)
        let payType = SelectingMethods.selectPayType(payType: payTypeString)
        let series = itemData["series"] as? String
        
        // Parsing additional nested data
        let setData = itemData["set"] as? [String: Any]
        let set = setData?["partOf"] as? String
        
        let bpData = itemData["battlepass"] as? [String: Any]
        let displayData = bpData?["displayText"] as? [String: Any]
        let introduction = displayData?["chapterSeason"] as? String ?? ""
        
        // Formatting the release date using a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let releaseDate = dateFormatter.date(from: releaseDateString) ?? .now
        
        return BattlePassItem(id: id, tier: tier, page: page, payType: payType, price: 1, rewardWall: rewardWall, levelWall: levelWall, type: type, name: name, description: description, rarity: rarity, series: series, releaseDate: releaseDate, image: image, shareImage: shareImage, video: video, introduction: introduction, set: set)
    }
}

