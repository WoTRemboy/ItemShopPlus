//
//  JSONParseItemVideo.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.04.2024.
//

import Foundation
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "ItemVideoModule", category: "JSONParse")

extension ItemVideo {
    /// Parses JSON data and creates an `ItemVideo` instance
    /// - Parameter sharingJSON: A JSON object representing an item video
    /// - Returns: An optional `ItemVideo` instance if the parsing is successful, otherwise `nil`
    static func sharingParse(sharingJSON: Any) -> ItemVideo? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let videoData = data["previewVideos"] as? [[String: Any]],
              let video = videoData.first?["url"] as? String
        else {
            logger.error("Failed to parse ItemVideo sharing data")
            return nil
        }
        
        return ItemVideo(id: id, video: video)
    }
}
