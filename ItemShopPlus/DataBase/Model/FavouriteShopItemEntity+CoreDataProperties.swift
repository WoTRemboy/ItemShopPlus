//
//  FavouriteShopItemEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

/// Core Data entity class representing a favourite shop item
@objc(FavouriteShopItemEntity)
public class FavouriteShopItemEntity: NSManagedObject {}

extension FavouriteShopItemEntity {

    /// Fetch request for fetching `FavouriteShopItemEntity` objects
    /// - Returns: A `NSFetchRequest` for `FavouriteShopItemEntity`
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteShopItemEntity> {
        return NSFetchRequest<FavouriteShopItemEntity>(entityName: "FavouriteShopItemEntity")
    }
    
    // MARK: - Properties
    
    /// Unique identifier for the shop item
    @NSManaged public var id: String?
    /// Name of the shop item
    @NSManaged public var name: String?
    /// Description of the shop item
    @NSManaged public var itemDescription: String?
    /// Type of the shop item (e.g., outfit, emote)
    @NSManaged public var type: String?
    /// Date when the item was first released
    @NSManaged public var firstReleaseDate: Date?
    /// Date when the item was previously available for sale
    @NSManaged public var previousReleaseDate: Date?
    /// Date when the item is expected to expire or leave the shop
    @NSManaged public var expiryDate: Date?
    /// Boolean indicating if the item can be purchased
    @NSManaged public var buyAllowed: Bool
    /// Price of the item in virtual currency
    @NSManaged public var price: Int32
    /// Regular price of the item (before any discounts)
    @NSManaged public var regularPrice: Int32
    /// Series or set to which the item belongs, if applicable
    @NSManaged public var series: String?
    /// Section in the shop where the item is displayed
    @NSManaged public var section: String?
    /// Boolean indicating if the item has an associated video
    @NSManaged public var video: Bool
    /// Rarity level of the item (e.g., common, rare)
    @NSManaged public var rarity: String?
    /// Set of granted items associated with this shop item
    @NSManaged public var grantedItems: NSSet?
    /// Set of images associated with this shop item
    @NSManaged public var images: NSSet?

}

// MARK: - Generated accessors for grantedItems

extension FavouriteShopItemEntity {

    /// Adds a granted item to the shop item's granted items set
    /// - Parameter value: The granted item to add
    @objc(addGrantedItemsObject:)
    @NSManaged public func addToGrantedItems(_ value: ShopGrantedItemEntity)
    
    /// Removes a granted item from the shop item's granted items set
    /// - Parameter value: The granted item to remove
    @objc(removeGrantedItemsObject:)
    @NSManaged public func removeFromGrantedItems(_ value: ShopGrantedItemEntity)
    
    /// Adds multiple granted items to the shop item's granted items set
    /// - Parameter values: A set of granted items to add
    @objc(addGrantedItems:)
    @NSManaged public func addToGrantedItems(_ values: NSSet)
    
    /// Removes multiple granted items from the shop item's granted items set
    /// - Parameter values: A set of granted items to remove
    @objc(removeGrantedItems:)
    @NSManaged public func removeFromGrantedItems(_ values: NSSet)

}

// MARK: - Generated accessors for images

extension FavouriteShopItemEntity {

    /// Adds an image to the shop item's images set
    /// - Parameter value: The image to add
    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ShopItemImageEntity)
    
    /// Removes an image from the shop item's images set
    /// - Parameter value: The image to remove
    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ShopItemImageEntity)
    
    /// Adds multiple images to the shop item's images set
    /// - Parameter values: A set of images to add
    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)
    
    /// Removes multiple images from the shop item's images set
    /// - Parameter values: A set of images to remove
    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: - Identifiable

extension FavouriteShopItemEntity : Identifiable {}
