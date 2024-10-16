//
//  ItemVideoModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.04.2024.
//

import Foundation

/// A model representing a video associated with an item in the shop
struct ItemVideo {
    /// The unique identifier for the item
    let id: String
    /// The URL or file path of the video associated with the item
    let video: String
    
    /// A static instance representing an empty or uninitialized video
    static let emptyVideo = ItemVideo(id: "", video: "")
}
