//
//  ShopItemImageEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

/// Core Data entity class representing an image related to a shop item
@objc(ShopItemImageEntity)
public class ShopItemImageEntity: NSManagedObject {}

extension ShopItemImageEntity {

    /// Fetch request for fetching `ShopItemImageEntity` objects
    /// - Returns: A `NSFetchRequest` for `ShopItemImageEntity`
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopItemImageEntity> {
        return NSFetchRequest<ShopItemImageEntity>(entityName: "ShopItemImageEntity")
    }
    
    // MARK: - Properties

    /// The name or description of the image
    @NSManaged public var name: String?
    /// The URL or local path to the image file
    @NSManaged public var image: String?
    /// The relationship linking this image to its parent `FavouriteShopItemEntity`
    @NSManaged public var favouriteShopItem: FavouriteShopItemEntity?

}

// MARK: - Identifiable

extension ShopItemImageEntity : Identifiable {}
