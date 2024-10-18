//
//  JSONMapsParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.02.2024.
//

import Foundation
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "MapModule", category: "JSONParse")

extension Map {
    /// Parses a JSON object to create a `Map` instance
    /// - Parameter sharingJSON: The JSON object representing the map data
    /// - Returns: A `Map` instance if parsing is successful, otherwise `nil`
    static func sharingParse(sharingJSON: Any) -> Map? {
        // Ensure that the provided JSON is a dictionary and retrieve the necessary fields
        guard let data = sharingJSON as? [String: Any],
              let patch = data["patchVersion"] as? String,
              let release = data["releaseDate"] as? String,
              let image = data["url"] as? String,
              let poiImage = data["urlPOI"] as? String
        else {
            logger.error("Failed to parse Map sharing data")
            return nil
        }
        
        // Convert the release date string to a Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: release) ?? .now // Fallback to the current date if parsing fails
        
        return Map(patchVersion: patch, realeseDate: date, clearImage: image, poiImage: poiImage)
    }
}
