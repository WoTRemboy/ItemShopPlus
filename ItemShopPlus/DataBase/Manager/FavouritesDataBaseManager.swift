//
//  FavouritesDataBaseManager.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 05.07.2024.
//

import Foundation
import CoreData

final class FavouritesDataBaseManager {
    private(set) var items = [ShopItem]()
    static let shared = FavouritesDataBaseManager()
    
    init() {
        loadFromDataBase()
    }
    
    func fetchItem(withID id: String, in context: NSManagedObjectContext) -> FavouriteShopItemEntity? {
        let fetchRequest: NSFetchRequest<FavouriteShopItemEntity> = FavouriteShopItemEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching item from database: \(error)")
            return nil
        }
    }

    private func createCoreDataShopItem(from item: ShopItem, in context: NSManagedObjectContext) -> FavouriteShopItemEntity {
        
        let coreDataItem = FavouriteShopItemEntity(context: context)
        coreDataItem.id = item.id
        coreDataItem.name = item.name
        coreDataItem.itemDescription = item.description
        coreDataItem.type = item.type
        coreDataItem.firstReleaseDate = item.firstReleaseDate
        coreDataItem.previousReleaseDate = item.previousReleaseDate
        coreDataItem.expiryDate = item.expiryDate
        coreDataItem.buyAllowed = item.buyAllowed
        coreDataItem.price = Int32(item.price)
        coreDataItem.regularPrice = Int32(item.regularPrice)
        coreDataItem.series = item.series
        coreDataItem.section = item.section
        coreDataItem.video = item.video
        coreDataItem.rarity = Rarity.rarityToString(rarity: item.rarity)
        coreDataItem.grantedItems = NSSet(array: item.granted.map { createCoreDataGrantedItem(from: $0 ?? GrantedItem.emptyItem(), parent: coreDataItem, in: context) })
        coreDataItem.images = NSSet(array: item.images.map { createCoreDataShopImage(from: $0, parent: coreDataItem, in: context) })
        
        return coreDataItem
    }
    
    private func createCoreDataGrantedItem(from item: GrantedItem, parent: FavouriteShopItemEntity, in context: NSManagedObjectContext) -> ShopGrantedItemEntity {
        
        let coreDataItem = ShopGrantedItemEntity(context: context)
        coreDataItem.id = item.id
        coreDataItem.name = item.name
        coreDataItem.typeID = item.typeID
        coreDataItem.type = item.type
        coreDataItem.itemDescription = item.description
        coreDataItem.series = item.series
        coreDataItem.image = item.image
        coreDataItem.video = item.video
        coreDataItem.rarity = Rarity.rarityToString(rarity: item.rarity ?? .common)
        coreDataItem.parentShopItem = parent
        
        return coreDataItem
    }
    
    private func createCoreDataShopImage(from item: ShopItemImage, parent: FavouriteShopItemEntity, in context: NSManagedObjectContext) -> ShopItemImageEntity {
        
        let coreDataItem = ShopItemImageEntity(context: context)
        coreDataItem.name = item.mode
        coreDataItem.image = item.image
        coreDataItem.favouriteShopItem = parent
        
        return coreDataItem
    }
    
    func insertToDataBase(item: ShopItem) {
        let context = CoreDataManager.shared.backgroundContext()
        
        context.perform {
            _ = self.createCoreDataShopItem(from: item, in: context)
            
            do {
                try context.save()
                print("Inserted into database CoreData")
                self.loadFromDataBase()
            } catch {
                print("Inserting into database error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFromDataBase(at itemID: String) {
        let context = CoreDataManager.shared.backgroundContext()
        
        context.perform {
            if let existingItem = self.fetchItem(withID: itemID, in: context) {
                context.delete(existingItem)
                
                do {
                    try context.save()
                    print("Deleted from database CoreData")
                    self.loadFromDataBase()
                } catch {
                    print("Deleting from database error: \(error)")
                }
            }
        }
    }
    
    func loadFromDataBase() {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<FavouriteShopItemEntity> = NSFetchRequest(entityName: "FavouriteShopItemEntity")
        
        do {
            let items = try context.fetch(fetchRequest)
            self.items = items.map { ShopItem.toShopItem(from: $0) }
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
}
