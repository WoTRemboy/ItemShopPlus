//
//  WidgetShopItemParse.swift
//  ItemShopPlusWidgetExtension
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation

extension WidgetShopItem {
    /// Parses a JSON object into a `WidgetShopItem` instance
    /// - Parameter sharingJSON: The JSON object that contains the shop item data
    /// - Returns: A `WidgetShopItem` if parsing is successful, or `nil` if the required fields are missing or invalid
    static func sharingParse(sharingJSON: Any) -> WidgetShopItem? {
        // Parse required fields from the input JSON object
        guard let data = sharingJSON as? [String: Any],
              let id = data["mainId"] as? String,
              let name = data["displayName"] as? String,
              
              let assetsData = data["displayAssets"] as? [[String: Any]],
              let priceData = data["price"] as? [String: Any],
              let offerData = data["offerDates"] as? [String: Any],
              
              let buyAllowed = data["buyAllowed"] as? Bool,
              buyAllowed == true
        else {
            // Return nil if any required fields are missing or invalid
            return nil
        }
        
        // Retrieve the first asset data and extract the image background if available
        let asset = assetsData.first
        var image = asset?["background"] as? String ?? String()
        
        // Use granted data to find an image override
        if let grantedData = data["granted"] as? [[String: Any]], let granted = grantedData.first {
            let imagesData = granted["images"] as? [String: Any]
            if let imageData = imagesData?["icon_background"] as? String {
                image = imageData
            }
        }
        
        // Parse the item's pricing information
        let finalPrice = priceData["finalPrice"] as? Int ?? 0
        let regularPrice = priceData["regularPrice"] as? Int ?? 0
        
        // Extract the banner information
        let bannerData = data["banner"] as? [String: Any]
        let bannerName = bannerData?["id"] as? String ?? String()
        let banner = WidgetBanner.init(rawValue: bannerName) ?? .null
        
        // Parse the item's previous release date
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
