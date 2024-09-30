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
    
    private var context: NSManagedObjectContext!
    
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
    
    override func tearDownWithError() throws {
        // Clear the context after each test
        context = nil
        try super.tearDownWithError()
    }
    
    // Test default emptyShopItem initialization
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

    // Test toggling the isFavourite property
    internal func testFavouriteToggle() {
        var item = ShopItem.emptyShopItem
        XCTAssertFalse(item.isFavourite)
        
        item.favouriteToggle()
        XCTAssertTrue(item.isFavourite)
        
        item.favouriteToggle()
        XCTAssertFalse(item.isFavourite)
    }
    
    // Test ShopItem equality by ID
    internal func testShopItemEquality() {
        let item1 = ShopItem(id: "001", name: "Cool Item", description: "A cool item", type: "Outfit", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 100, regularPrice: 120, series: nil, rarity: .rare, granted: [], section: "Featured", banner: .new, video: false)
        let item2 = ShopItem(id: "001", name: "Cool Item2", description: "A cool item2", type: "Outfit2", images: [], firstReleaseDate: .now, previousReleaseDate: .now, expiryDate: .now, buyAllowed: false, price: 90, regularPrice: 100, series: nil, rarity: .common, granted: [], section: "Featured2", banner: .null, video: true)
        
        XCTAssertEqual(item1, item2)
    }
    
    // Test ShopItem inequality
    internal func testShopItemInequality() {
        let item1 = ShopItem(id: "001", name: "Cool Item", description: "A cool item", type: "Outfit", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 100, regularPrice: 120, series: nil, rarity: .rare, granted: [], section: "Featured", banner: .new, video: false)
        let item2 = ShopItem(id: "002", name: "Cooler Item", description: "A cooler item", type: "Backpack", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil, buyAllowed: true, price: 150, regularPrice: 180, series: nil, rarity: .epic, granted: [], section: "Daily", banner: .sale, video: true)
        
        XCTAssertNotEqual(item1, item2)
    }
    
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
    
    // Test ShopItem creation from FavouriteShopItemEntity
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
    
    // Test default emptyItem initialization
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
    
    // Test GrantedItem creation from ShopGrantedItemEntity
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
    
    // Test ShopItemImage creation from ShopItemImageEntity
    internal func testShopItemImageFromEntity() {
        let mockEntity = ShopItemImageEntity(context: context)
        mockEntity.name = "Product.BR"
        mockEntity.image = "br_image.png"
        
        let shopItemImage = ShopItemImage.toItemImage(from: mockEntity)
        
        XCTAssertEqual(shopItemImage.mode, "Product.BR")
        XCTAssertEqual(shopItemImage.image, "br_image.png")
    }
}
