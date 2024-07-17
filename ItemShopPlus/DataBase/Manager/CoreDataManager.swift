//
//  CoreDataManager.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 05.07.2024.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavouriteShopItem")
        container.loadPersistentStores {_, error in
            _ = error.map { fatalError("Persistent container (Favourites DB) error: \($0)") }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("SaveContext (Favourites DB) error: \(error)")
            }
        }
    }
}
