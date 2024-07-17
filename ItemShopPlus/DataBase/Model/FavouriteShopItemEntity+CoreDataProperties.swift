//
//  FavouriteShopItemEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

@objc(FavouriteShopItemEntity)
public class FavouriteShopItemEntity: NSManagedObject {}

extension FavouriteShopItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteShopItemEntity> {
        return NSFetchRequest<FavouriteShopItemEntity>(entityName: "FavouriteShopItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var type: String?
    @NSManaged public var firstReleaseDate: Date?
    @NSManaged public var previousReleaseDate: Date?
    @NSManaged public var expiryDate: Date?
    @NSManaged public var buyAllowed: Bool
    @NSManaged public var price: Int32
    @NSManaged public var regularPrice: Int32
    @NSManaged public var series: String?
    @NSManaged public var section: String?
    @NSManaged public var video: Bool
    @NSManaged public var rarity: String?
    @NSManaged public var grantedItems: NSSet?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for grantedItems
extension FavouriteShopItemEntity {

    @objc(addGrantedItemsObject:)
    @NSManaged public func addToGrantedItems(_ value: ShopGrantedItemEntity)

    @objc(removeGrantedItemsObject:)
    @NSManaged public func removeFromGrantedItems(_ value: ShopGrantedItemEntity)

    @objc(addGrantedItems:)
    @NSManaged public func addToGrantedItems(_ values: NSSet)

    @objc(removeGrantedItems:)
    @NSManaged public func removeFromGrantedItems(_ values: NSSet)

}

// MARK: Generated accessors for images
extension FavouriteShopItemEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ShopItemImageEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ShopItemImageEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

extension FavouriteShopItemEntity : Identifiable {

}
