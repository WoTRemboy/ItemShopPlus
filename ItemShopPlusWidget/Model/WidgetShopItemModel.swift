//
//  WidgetShopItemModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation

struct WidgetShopItem: Equatable, Hashable {
    let id: String
    let name: String
    let image: String
    let buyAllowed: Bool
    let price: Int
    let regularPrice: Int
    let banner: WidgetBanner
    
    static let emptyShopItem = WidgetShopItem(id: "", name: Texts.Widget.placeholderName, image: "", buyAllowed: false, price: 0, regularPrice: 0, banner: .null)
    
    static func == (lhs: WidgetShopItem, rhs: WidgetShopItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum WidgetBanner: String {
    case null = ""
    case new = "New"
}
