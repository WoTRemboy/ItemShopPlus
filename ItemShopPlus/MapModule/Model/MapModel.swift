//
//  MapModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.02.2024.
//

import Foundation

struct Map {
    let patchVersion: String
    let realeseDate: Date
    let clearImage: String
    let poiImage: String
}

enum NavigationMapButtonType {
    case location
    case version
}
