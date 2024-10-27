//
//  ShopModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import Foundation

/// A struct representing an item in the shop
struct ShopItem: Equatable, Hashable {
    /// The unique identifier of the shop item
    let id: String
    /// The name of the shop item
    let name: String
    /// A description of the shop item
    let description: String
    /// The type or category of the shop item
    let type: String
    /// An array of images associated with the shop item
    let images: [ShopItemImage]
    /// The first release date of the shop item
    let firstReleaseDate: Date?
    /// The previous release date of the shop item
    let previousReleaseDate: Date?
    /// The expiry date of the shop item
    let expiryDate: Date?
    /// Indicates whether the item can be bought
    let buyAllowed: Bool
    /// The current (with sale) price of the item
    let price: Int
    /// The final price of the item
    let regularPrice: Int
    /// The series associated with the item
    let series: String?
    /// The rarity of the item
    let rarity: Rarity
    /// An array of granted items associated with the shop item
    let granted: [GrantedItem?]
    /// The section of the shop where the item is displayed
    let section: String
    /// A banner associated with the shop item like new entry
    let banner: Banner
    /// Indicates whether the item has an associated video
    let video: Bool
    /// Indicates whether the item is marked as a favourite
    var isFavourite: Bool = false
    
    /// An empty shop item instance used for initializing placeholder data
    static let emptyShopItem = ShopItem(id: "", name: "", description: "", type: "", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil,  buyAllowed: false, price: 0, regularPrice: 0, series: "", rarity: .common, granted: [], section: "", banner: .null, video: false)
    
    /// Toggles the `isFavourite` status of the shop item
    mutating func favouriteToggle() {
        isFavourite.toggle()
    }
    
    /// Compares two shop items for equality based on their `id`
    static func == (lhs: ShopItem, rhs: ShopItem) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the `id` property into the given hasher
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Converts a `FavouriteShopItemEntity` Core Data entity into a `ShopItem`
    /// - Parameter item: The `FavouriteShopItemEntity` to convert
    /// - Returns: A `ShopItem` representation of the Core Data entity
    static func toShopItem(from item: FavouriteShopItemEntity) -> ShopItem {
        let id = item.id ?? String()
        let name = item.name ?? String()
        let description = item.itemDescription ?? String()
        let type = item.type ?? String()
        let firstReleaseDate = item.firstReleaseDate
        let previousReleaseDate = item.previousReleaseDate
        let expiryDate = item.expiryDate
        let buyAllowed = item.buyAllowed
        let price = Int(item.price)
        let regularPrice = Int(item.regularPrice)
        let series = item.series
        let rarity = SelectingMethods.selectRarity(rarityText: item.rarity)
        let section = item.section ?? String()
        let video = item.video
        
        let context = CoreDataManager.shared.mainContext
        
        var grantedItems = [GrantedItem]()
        var images = [ShopItemImage]()

        // Perform Core Data operations within the context
        context.performAndWait {
            if let extractedItems = item.grantedItems?.allObjects as? [ShopGrantedItemEntity] {
                grantedItems = extractedItems.map { GrantedItem.toGrantedItem(from: $0) }
                let sortOrder = [
                    Texts.ItemSortOrder.outfit, Texts.ItemSortOrder.emote,
                    Texts.ItemSortOrder.backpack, Texts.ItemSortOrder.pickaxe,
                    Texts.ItemSortOrder.glider, Texts.ItemSortOrder.wrap,
                    Texts.ItemSortOrder.loadingscreen, Texts.ItemSortOrder.music,
                    Texts.ItemSortOrder.sparkSong, Texts.ItemSortOrder.spray,
                    Texts.ItemSortOrder.bannertoken, Texts.ItemSortOrder.contrail,
                    Texts.ItemSortOrder.buildingProp, Texts.ItemSortOrder.buildingSet]
                grantedItems.sort(by: {
                    guard let first = sortOrder.firstIndex(of: $0.typeID),
                          let second = sortOrder.firstIndex(of: $1.typeID) else {
                        return false
                    }
                    return first < second
                })
            }
        
            if let extractedImages = item.images?.allObjects as? [ShopItemImageEntity] {
                images = extractedImages.map { ShopItemImage.toItemImage(from: $0) }
                
                let sortOrder = ["Product.BR", "Product.Juno", "Product.DelMar"]
                images.sort(by: {
                    guard let first = sortOrder.firstIndex(of: $0.mode),
                          let second = sortOrder.firstIndex(of: $1.mode) else {
                        return false
                    }
                    return first < second
                })
            }
        }
        
        return ShopItem(id: id, name: name, description: description, type: type, images: images, firstReleaseDate: firstReleaseDate, previousReleaseDate: previousReleaseDate, expiryDate: expiryDate, buyAllowed: buyAllowed, price: price, regularPrice: regularPrice, series: series, rarity: rarity, granted: grantedItems, section: section, banner: .null, video: video, isFavourite: true)
    }
}

// MARK: - GrantedItem

/// A struct representing an item granted as part of a shop item bundle
struct GrantedItem {
    /// The unique identifier of the granted item
    let id: String
    /// The type identifier of the granted item
    let typeID: String
    /// The type name of the granted item
    let type: String
    /// The name of the granted item
    let name: String
    /// A description of the granted item
    let description: String
    /// The rarity of the granted item
    let rarity: Rarity?
    /// The series associated with the granted item
    let series: String?
    /// The image URL of the granted item
    let image: String
    /// The image URL of the granted item to share
    let shareImage: String
    /// The video URL associated with the granted item
    let video: String?
    
    /// An empty granted item instance used for initializing placeholder data
    static let emptyItem = {
        GrantedItem(id: "", typeID: "", type: "", name: "", description: "", rarity: .common, series: "", image: "", shareImage: "", video: "")
    }
    
    /// Converts a `ShopGrantedItemEntity` Core Data entity into a `GrantedItem`
    /// - Parameter item: The `ShopGrantedItemEntity` to convert
    /// - Returns: A `GrantedItem` representation of the Core Data entity
    static func toGrantedItem(from item: ShopGrantedItemEntity) -> GrantedItem {
        let id = item.id ?? String()
        let typeID = item.typeID ?? String()
        let type = item.type ?? String()
        let name = item.name ?? String()
        let description = item.itemDescription ?? String()
        let rarity = SelectingMethods.selectRarity(rarityText: item.rarity)
        let series = item.series
        let image = item.image ?? String()
        let shareImage = item.shareImage ?? String()
        let video = item.video
        
        return GrantedItem(id: id, typeID: typeID, type: type, name: name, description: description, rarity: rarity, series: series, image: image, shareImage: shareImage, video: video)
    }
}

// MARK: - ShopItemImage

/// A struct representing an image associated with a shop item
struct ShopItemImage {
    /// The mode the image is used (BR, Lego or Racing)
    let mode: String
    /// The URL of the image
    let image: String
    
    /// An empty image instance used for initializing placeholder data
    let emptyImage = {
        ShopItemImage(mode: "", image: "")
    }
    
    /// Converts a `ShopItemImageEntity` Core Data entity into a `ShopItemImage`
    /// - Parameter item: The `ShopItemImageEntity` to convert
    /// - Returns: A `ShopItemImage` representation of the Core Data entity
    static func toItemImage(from item: ShopItemImageEntity) -> ShopItemImage {
        let mode = item.name ?? String()
        let image = item.image ?? String()
        
        return ShopItemImage(mode: mode, image: image)
    }
}

// MARK: - Banner

/// An enum representing the different types of banners associated with shop items
enum Banner {
    case null
    case new
    case sale
    case free
    case emote
    case pickaxe
}
