//
//  CoreDataManager.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 05.07.2024.
//

import Foundation
import CoreData
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "DataBaseModel", category: "DataManager")

/// A class responsible for managing the Core Data stack, specifically for saving and retrieving data related to `FavouriteShopItem`
final class CoreDataManager {
    /// Shared instance for accessing the `CoreDataManager`
    static let shared = CoreDataManager()
    /// Private initializer to ensure the singleton pattern
    private init() {}
    
    // MARK: - Persistent Container
    
    /// The persistent container that manages the Core Data stack
    internal lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouriteShopItem")
        // Load the persistent store and handle errors if any
        container.loadPersistentStores {_, error in
            _ = error.map { fatalError("Persistent container (Favourites DB) error: \($0)") }
        }
        return container
    }()
    
    // MARK: - Context Methods
    
    /// The main context for interacting with the Core Data store
    internal var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// Saves any changes made in the main context to the persistent store
    internal func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.error("SaveContext (Favourites DB) error: \(error)")
            }
        }
    }
}
