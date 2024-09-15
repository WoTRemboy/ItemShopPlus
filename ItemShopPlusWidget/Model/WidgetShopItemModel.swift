//
//  WidgetShopItemModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation
import WidgetKit
import UIKit

struct WidgetShopItem: Equatable, Hashable {
    let id: String
    let name: String
    let image: String
    let buyAllowed: Bool
    let price: Int
    let regularPrice: Int
    let previousReleaseDate: Date
    let banner: WidgetBanner
    
    static let emptyShopItem = WidgetShopItem(id: "", name: "", image: "", buyAllowed: false, price: -100, regularPrice: 0, previousReleaseDate: .now, banner: .null)
    
    static let mockShopItem = WidgetShopItem(id: "", name: "Galaxy Scout", image: "", buyAllowed: true, price: 2000, regularPrice: 2000, previousReleaseDate: .now, banner: .new)
    
    static func == (lhs: WidgetShopItem, rhs: WidgetShopItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ShopEntry: TimelineEntry {
    let date: Date
    let shopItem: WidgetShopItem
    let image: UIImage?
}

enum WidgetBanner: String {
    case null = ""
    case new = "New"
}
