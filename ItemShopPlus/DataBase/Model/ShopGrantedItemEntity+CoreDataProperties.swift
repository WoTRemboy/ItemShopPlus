//
//  ShopGrantedItemEntity+CoreDataProperties.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//
//

import Foundation
import CoreData

@objc(ShopGrantedItemEntity)
public class ShopGrantedItemEntity: NSManagedObject {}

extension ShopGrantedItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopGrantedItemEntity> {
        return NSFetchRequest<ShopGrantedItemEntity>(entityName: "ShopGrantedItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var typeID: String?
    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var series: String?
    @NSManaged public var image: String?
    @NSManaged public var video: String?
    @NSManaged public var rarity: String?
    @NSManaged public var parentShopItem: FavouriteShopItemEntity?

}

extension ShopGrantedItemEntity : Identifiable {

}
