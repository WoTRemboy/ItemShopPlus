//
//  MapModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.02.2024.
//

import Foundation

/// A struct representing a map with its relevant metadata
struct Map {
    /// The version of the map based on the patch release.
    let patchVersion: String
    /// The release date of the map.
    let realeseDate: Date
    /// A URL string for the clear map image without any points of interest (POI).
    let clearImage: String
    /// A URL string for the map image that includes points of interest (POI).
    let poiImage: String
}

/// An enum representing the types of buttons used for navigation on the map
enum NavigationMapButtonType {
    /// Button for selecting a specific location on the map.
    case location
    /// Button for displaying or interacting with the map version.
    case version
}
