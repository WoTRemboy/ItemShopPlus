//
//  WidgetShopItemModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/14/24.
//

import Foundation
import WidgetKit
import UIKit

// MARK: - WidgetShopItem

/// A model representing an item in the widget's shop display
struct WidgetShopItem: Equatable, Hashable {
    /// The unique identifier for the shop item
    let id: String
    /// The name of the shop item
    let name: String
    /// The URL of the image associated with the shop item
    let image: String
    /// Indicates whether purchasing the shop item is allowed
    let buyAllowed: Bool
    /// The current price of the shop item in VBucks currency
    let price: Int
    /// The regular price of the shop item, used if there is a discount
    let regularPrice: Int
    /// The date when the item was previously released in the shop
    let previousReleaseDate: Date
    /// The banner type associated with the shop item, such as "New" or no banner
    let banner: WidgetBanner
    
    /// An empty instance of `WidgetShopItem`, used as a placeholder for uninitialized and empty items
    static let emptyShopItem = WidgetShopItem(id: "", name: "", image: "", buyAllowed: false, price: -100, regularPrice: 0, previousReleaseDate: .now, banner: .null)
    
    /// A mock instance of `WidgetShopItem`, used for UI previews
    static let mockShopItem = WidgetShopItem(id: "", name: "Galaxy Scout", image: "", buyAllowed: true, price: 2000, regularPrice: 2000, previousReleaseDate: .now, banner: .new)
    
    
    /// Compares two `WidgetShopItem` instances for equality based on their `id` properties
    /// - Parameters:
    ///   - lhs: The left-hand side `WidgetShopItem` being compared
    ///   - rhs: The right-hand side `WidgetShopItem` being compared
    /// - Returns: `true` if the `id` properties of both items are equal, otherwise `false`
    static func == (lhs: WidgetShopItem, rhs: WidgetShopItem) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the essential components of the `WidgetShopItem` to produce a unique identifier
    /// - Parameter hasher: The `Hasher` instance used to combine the values into a hash
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - ShopEntry

/// A model representing an entry in the widget's timeline
struct ShopEntry: TimelineEntry {
    /// The date when the timeline entry was created
    let date: Date
    /// The `WidgetShopItem` associated with this timeline entry
    let shopItem: WidgetShopItem
    /// The image to be displayed for the shop item in the widget
    let image: UIImage?
}

// MARK: - WidgetBanner

/// An enum representing the banners that can be associated with shop items in the widget (e.g., "New" items)
enum WidgetBanner: String {
    // No banner associated with the item
    case null = ""
    // The "New" banner indicating that the item is newly added to the shop
    case new = "New"
}
