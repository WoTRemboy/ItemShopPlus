//
//  ShopItemImageEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

@objc(ShopItemImageEntity)
public class ShopItemImageEntity: NSManagedObject {}

extension ShopItemImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopItemImageEntity> {
        return NSFetchRequest<ShopItemImageEntity>(entityName: "ShopItemImageEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var favouriteShopItem: FavouriteShopItemEntity?

}

extension ShopItemImageEntity : Identifiable {

}
