//
//  ShopGrantedItemEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

/// Core Data entity class representing a granted item within a shop item
@objc(ShopGrantedItemEntity)
public class ShopGrantedItemEntity: NSManagedObject {}

extension ShopGrantedItemEntity {

    /// Fetch request for fetching `ShopGrantedItemEntity` objects
    /// - Returns: A `NSFetchRequest` for `ShopGrantedItemEntity`
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopGrantedItemEntity> {
        return NSFetchRequest<ShopGrantedItemEntity>(entityName: "ShopGrantedItemEntity")
    }
    
    // MARK: - Properties
    
    /// Unique identifier for the granted item
    @NSManaged public var id: String?
    /// The identifier for the type of the granted item
    @NSManaged public var typeID: String?
    /// Type/category of the granted item (e.g., outfit, emote)
    @NSManaged public var type: String?
    /// Name of the granted item
    @NSManaged public var name: String?
    /// Description of the granted item
    @NSManaged public var itemDescription: String?
    /// Series or set to which the granted item belongs, if applicable
    @NSManaged public var series: String?
    /// URL or local path for the item's primary image
    @NSManaged public var image: String?
    /// URL or local path for the item's shared image
    @NSManaged public var shareImage: String?
    /// URL or local path for the item's associated video, if available
    @NSManaged public var video: String?
    /// Rarity level of the granted item (e.g., common, rare)
    @NSManaged public var rarity: String?
    /// The parent `FavouriteShopItemEntity` this granted item belongs to
    @NSManaged public var parentShopItem: FavouriteShopItemEntity?

}

// MARK: - Identifiable

extension ShopGrantedItemEntity : Identifiable {}
