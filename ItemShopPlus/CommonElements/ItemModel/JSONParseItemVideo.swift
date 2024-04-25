//
//  JSONParseItemVideo.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.04.2024.
//

import Foundation

extension ItemVideo {
    static func sharingParse(sharingJSON: Any) -> ItemVideo? {
        guard let data = sharingJSON as? [String: Any],
              let id = data["id"] as? String,
              let videoData = data["previewVideos"] as? [[String: Any]],
              let video = videoData.first?["url"] as? String
        else {
            return nil
        }
        
        return ItemVideo(id: id, video: video)
    }
}
