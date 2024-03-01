//
//  JSONMapsParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.02.2024.
//

import Foundation

extension Map {
    static func sharingParse(sharingJSON: Any) -> Map? {
        guard let data = sharingJSON as? [String: Any],
              let patch = data["patchVersion"] as? String,
              let release = data["releaseDate"] as? String,
              let image = data["url"] as? String,
              let poiImage = data["urlPOI"] as? String
        else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: release) ?? .now
        
        return Map(patchVersion: patch, realeseDate: date, clearImage: image, poiImage: poiImage)
    }
}
