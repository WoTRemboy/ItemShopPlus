//
//  ShopModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/29/24.
//

import XCTest
import CoreData
@testable import ItemShopPlus

final class ShopModelTests: XCTestCase {

    // MARK: - ShopItem Tests
    
    /// The in-memory `NSManagedObjectContext` used for testing CoreData models
    private var context: NSManagedObjectContext!
    
    /// This method initializes the `context` to use an in-memory store, which does not persist any data
    /// - Throws: If there is an issue with the test setup
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // Creates in-memory NSPersistentContainer
        let persistentContainer = NSPersistentContainer(name: "FavouriteShopItem")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // In-memory store
        persistentContainer.persistentStoreDescriptions = [description]
        
        // Loads persistent
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Loading error of in-memory persistent: \(error)")
            }
        }
        
        // Getting the context
        context = persistentContainer.viewContext
    }
    
    /// Tears down the `context` and clears all data after each test
    /// - Throws: If there is an issue with the teardown
    override func tearDownWithError() throws {
        // Clear the context after each test
        context = nil
        try super.tearDownWithError()
    }
    
    /// Test the default initialization of an empty `ShopItem`
    internal func testEmptyShopItem() {
        let emptyItem = ShopItem.emptyShopItem
        
        XCTAssertEqual(emptyItem.id, "")
        XCTAssertEqual(emptyItem.name, "")
        XCTAssertEqual(emptyItem.description, "")
        XCTAssertEqual(emptyItem.type, "")
        XCTAssertEqual(emptyItem.images.count, 0)
        XCTAssertNil(emptyItem.firstReleaseDate)
        XCTAssertNil(emptyItem.previousReleaseDate)
        XCTAssertNil(emptyItem.expiryDate)
        XCTAssertFalse(emptyItem.buyAllowed)
        XCTAssertEqual(emptyItem.price, 0)
        XCTAssertEqual(emptyItem.regularPrice, 0)
        XCTAssertEqual(emptyItem.series, "")
        XCTAssertEqual(emptyItem.rarity, .common)
        XCTAssertEqual(emptyItem.granted.count, 0)
        XCTAssertEqual(emptyItem.section, "")
        XCTAssertEqual(emptyItem.banner, .null)
        XCTAssertFalse(emptyItem.video)
        XCTAssertFalse(emptyItem.isFavourite)
    }

    /// Test toggling the `isFavourite` property of `ShopItem`
    internal func testFavouriteToggle() {
        var item = ShopItem.emptyShopItem
        XCTAssertFalse(item.isFavourite)
        
        item.favouriteToggle()
        XCTAssertTrue(item.isFavourite)
        
        item.favouriteToggle()
        XCTAssertFalse(item.isFavourite)
    }
    
    /// Test equality of two `ShopItem` instances based on their `id`
    internal func testShopItemEquality() {
        let item1 = ShopItem(id: "001", name: "Cool Item", description: "A cool item", type: "Outfit", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 100, regularPrice: 120, series: nil, rarity: .rare, granted: [], section: "Featured", banner: .new, video: false)
        let item2 = ShopItem(id: "001", name: "Cool Item2", description: "A cool item2", type: "Outfit2", images: [], firstReleaseDate: .now, previousReleaseDate: .now, expiryDate: .now, buyAllowed: false, price: 90, regularPrice: 100, series: nil, rarity: .common, granted: [], section: "Featured2", banner: .null, video: true)
        
        XCTAssertEqual(item1, item2)
    }
    
    /// Test inequality of two `ShopItem` instances based on their `id`
    internal func testShopItemInequality() {
        let item1 = ShopItem(id: "001", name: "Cool Item", description: "A cool item", type: "Outfit", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 100, regularPrice: 120, series: nil, rarity: .rare, granted: [], section: "Featured", banner: .new, video: false)
        let item2 = ShopItem(id: "002", name: "Cooler Item", description: "A cooler item", type: "Backpack", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 150, regularPrice: 180, series: nil, rarity: .epic, granted: [], section: "Daily", banner: .sale, video: true)
        
        XCTAssertNotEqual(item1, item2)
    }
    
    /// Test creation of a `FavouriteShopItemEntity` in CoreData and saving it to the in-memory store
    /// - Throws: If there is an error during context saving
    internal func testFavouriteShopItemEntityCreation() throws {
        // Create an entity
        let favouriteItem = FavouriteShopItemEntity(context: context)
        favouriteItem.id = "001"
        favouriteItem.name = "Test Item"
        
        // Check that the object is created correctly
        XCTAssertEqual(favouriteItem.id, "001")
        XCTAssertEqual(favouriteItem.name, "Test Item")
        
        // Save the context
        XCTAssertNoThrow(try context.save())
    }
    
    /// Test conversion of a `FavouriteShopItemEntity` to a `ShopItem` object
    internal func testShopItemFromFavouriteShopItemEntity() {
        let mockEntity = FavouriteShopItemEntity(context: context)
        mockEntity.id = "123"
        mockEntity.name = "Item Name"
        mockEntity.itemDescription = "Item Description"
        mockEntity.type = "Item Type"
        mockEntity.price = 100
        mockEntity.regularPrice = 120
        mockEntity.rarity = "Rare"
        mockEntity.series = "Item Series"
        mockEntity.buyAllowed = true
        
        let shopItem = ShopItem.toShopItem(from: mockEntity)
        
        XCTAssertEqual(shopItem.id, "123")
        XCTAssertEqual(shopItem.name, "Item Name")
        XCTAssertEqual(shopItem.description, "Item Description")
        XCTAssertEqual(shopItem.type, "Item Type")
        XCTAssertEqual(shopItem.price, 100)
        XCTAssertEqual(shopItem.regularPrice, 120)
        XCTAssertEqual(shopItem.rarity, .rare)
        XCTAssertEqual(shopItem.series, "Item Series")
        XCTAssertTrue(shopItem.buyAllowed)
    }
    
    // MARK: - GrantedItem Tests
    
    /// Test the default initialization of an empty `GrantedItem`
    internal func testEmptyGrantedItem() {
        let emptyItem = GrantedItem.emptyItem()
        
        XCTAssertEqual(emptyItem.id, "")
        XCTAssertEqual(emptyItem.typeID, "")
        XCTAssertEqual(emptyItem.type, "")
        XCTAssertEqual(emptyItem.name, "")
        XCTAssertEqual(emptyItem.description, "")
        XCTAssertEqual(emptyItem.rarity, .common)
        XCTAssertEqual(emptyItem.series, "")
        XCTAssertEqual(emptyItem.image, "")
        XCTAssertEqual(emptyItem.shareImage, "")
        XCTAssertEqual(emptyItem.video, "")
    }
    
    /// Test creation of a `GrantedItem` from a `ShopGrantedItemEntity` object
    internal func testGrantedItemFromEntity() {
        let mockEntity = ShopGrantedItemEntity(context: context)
        mockEntity.id = "001"
        mockEntity.typeID = "outfit"
        mockEntity.type = "Outfit"
        mockEntity.name = "Cool Outfit"
        mockEntity.itemDescription = "A rare outfit"
        mockEntity.rarity = "Rare"
        mockEntity.series = "Cool Series"
        mockEntity.image = "outfit_image.png"
        mockEntity.shareImage = "outfit_share.png"
        mockEntity.video = "outfit_video.mp4"
        
        let grantedItem = GrantedItem.toGrantedItem(from: mockEntity)
        
        XCTAssertEqual(grantedItem.id, "001")
        XCTAssertEqual(grantedItem.typeID, "outfit")
        XCTAssertEqual(grantedItem.type, "Outfit")
        XCTAssertEqual(grantedItem.name, "Cool Outfit")
        XCTAssertEqual(grantedItem.description, "A rare outfit")
        XCTAssertEqual(grantedItem.rarity, .rare)
        XCTAssertEqual(grantedItem.series, "Cool Series")
        XCTAssertEqual(grantedItem.image, "outfit_image.png")
        XCTAssertEqual(grantedItem.shareImage, "outfit_share.png")
        XCTAssertEqual(grantedItem.video, "outfit_video.mp4")
    }

    // MARK: - ShopItemImage Tests
    
    /// Test creation of a `ShopItemImage` from a `ShopItemImageEntity`
    internal func testShopItemImageFromEntity() {
        let mockEntity = ShopItemImageEntity(context: context)
        mockEntity.name = "Product.BR"
        mockEntity.image = "br_image.png"
        
        let shopItemImage = ShopItemImage.toItemImage(from: mockEntity)
        
        XCTAssertEqual(shopItemImage.mode, "Product.BR")
        XCTAssertEqual(shopItemImage.image, "br_image.png")
    }
}
