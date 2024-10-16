//
//  FavouritesDataBaseManager.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 05.07.2024.
//

import Foundation
import CoreData

/// Manages the storage and retrieval of favorite shop items in the Core Data database
final class FavouritesDataBaseManager {
    /// Holds the array of shop items stored in the database
    private(set) var items = [ShopItem]()
    /// Singleton instance for the manager
    static let shared = FavouritesDataBaseManager()
    
    /// Initializes the manager and loads data from the database
    internal init() {
        loadFromDataBase()
    }
    
    // MARK: - Fetching Methods
    
    /// Fetches an item from the database based on its ID
    /// - Parameters:
    ///   - id: The ID of the shop item to be fetched
    ///   - context: The `NSManagedObjectContext` in which the fetch request is performed
    /// - Returns: A `FavouriteShopItemEntity` if found, otherwise `nil`
    internal func fetchItem(withID id: String, in context: NSManagedObjectContext) -> FavouriteShopItemEntity? {
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
    
    // MARK: - Creation Methods

    /// Creates a Core Data shop item entity from a `ShopItem` model
    /// - Parameters:
    ///   - item: The `ShopItem` model to be stored
    ///   - context: The `NSManagedObjectContext` in which the entity will be created
    /// - Returns: A configured `FavouriteShopItemEntity`
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
        
        if !item.granted.isEmpty {
            coreDataItem.addToGrantedItems(NSSet(array: item.granted.map { createCoreDataGrantedItem(from: $0 ?? GrantedItem.emptyItem(), parent: coreDataItem, in: context) }))
        }

        if !item.images.isEmpty {
            coreDataItem.addToImages(NSSet(array: item.images.map { createCoreDataShopImage(from: $0, parent: coreDataItem, in: context) }))
        }
        
        return coreDataItem
    }
    
    /// Creates a Core Data granted item entity from a `GrantedItem` model
    /// - Parameters:
    ///   - item: The `GrantedItem` model to be stored
    ///   - parent: The parent `FavouriteShopItemEntity`
    ///   - context: The `NSManagedObjectContext` in which the entity will be created
    /// - Returns: A configured `ShopGrantedItemEntity`
    private func createCoreDataGrantedItem(from item: GrantedItem, parent: FavouriteShopItemEntity, in context: NSManagedObjectContext) -> ShopGrantedItemEntity {
        
        let coreDataItem = ShopGrantedItemEntity(context: context)
        coreDataItem.id = item.id
        coreDataItem.name = item.name
        coreDataItem.typeID = item.typeID
        coreDataItem.type = item.type
        coreDataItem.itemDescription = item.description
        coreDataItem.series = item.series
        coreDataItem.image = item.image
        coreDataItem.shareImage = item.shareImage
        coreDataItem.video = item.video
        coreDataItem.rarity = Rarity.rarityToString(rarity: item.rarity ?? .common)
        coreDataItem.parentShopItem = parent
        
        return coreDataItem
    }
    
    /// Creates a Core Data image entity from a `ShopItemImage` model
    ///
    /// - Parameters:
    ///   - item: The `ShopItemImage` model to be stored
    ///   - parent: The parent `FavouriteShopItemEntity`
    ///   - context: The `NSManagedObjectContext` in which the entity will be created
    /// - Returns: A configured `ShopItemImageEntity`
    private func createCoreDataShopImage(from item: ShopItemImage, parent: FavouriteShopItemEntity, in context: NSManagedObjectContext) -> ShopItemImageEntity {
        
        let coreDataItem = ShopItemImageEntity(context: context)
        coreDataItem.name = item.mode
        coreDataItem.image = item.image
        coreDataItem.favouriteShopItem = parent
        
        return coreDataItem
    }
    
    // MARK: - Database Operations
    
    /// Inserts a new shop item into the Core Data database
    /// - Parameter item: The `ShopItem` to be inserted into the database
    internal func insertToDataBase(item: ShopItem) {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { context in
            let _ = self.createCoreDataShopItem(from: item, in: context)
            
            do {
                try context.save()
                print("Inserted into database CoreData")
            } catch {
                print("Inserting into database error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Removes a shop item from the Core Data database based on its ID
    /// - Parameter itemID: The ID of the shop item to be removed
    internal func removeFromDataBase(at itemID: String) {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { context in
            if let existingItem = self.fetchItem(withID: itemID, in: context) {
                context.delete(existingItem)
                
                do {
                    try context.save()
                    print("Deleted from database CoreData")
                } catch {
                    print("Deleting from database error: \(error)")
                }
            }
        }
    }
    
    /// Loads all shop items from the Core Data database into the `items` array
    internal func loadFromDataBase() {
        let context = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<FavouriteShopItemEntity> = FavouriteShopItemEntity.fetchRequest()
        
        do {
            let items = try context.fetch(fetchRequest)
            self.items = items.map { ShopItem.toShopItem(from: $0) }
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
}
