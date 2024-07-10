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
    
//    func fetchAllItems(in context: NSManagedObjectContext) -> [FavouriteShopItemEntity] {
//        let fetchRequest: NSFetchRequest<FavouriteShopItemEntity> = FavouriteShopItemEntity.fetchRequest()
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results
//        } catch {
//            print("Error fetching items from database: \(error.localizedDescription)")
//            return []
//        }
//    }

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
        
        return coreDataItem
    }
    
//    func safeToDataBase(items: [ShopItem]) {
//        let context = CoreDataManager.shared.backgroundContext()
//        
//        context.perform {
//            let existingItems = self.fetchAllItems(in: context)
//            
//            
//        }
//    }
    
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
    
    func loadFromDataBase() {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<FavouriteShopItemEntity> = NSFetchRequest(entityName: "FavouriteShopItemEntity")
        
        do {
            let items = try context.fetch(fetchRequest)
            for item in items {
                let shopItem = ShopItem.toShopItem(from: item)
                self.items.append(shopItem)
            }
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
}
