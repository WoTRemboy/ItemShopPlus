//
//  ShopModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import Foundation

struct ShopItem: Equatable, Hashable {
    let id: String
    let name: String
    let description: String
    let type: String
    let images: [ShopItemImage]
    let firstReleaseDate: Date?
    let previousReleaseDate: Date?
    let expiryDate: Date?
    let buyAllowed: Bool
    let price: Int
    let regularPrice: Int
    let series: String?
    let rarity: Rarity
    let granted: [GrantedItem?]
    let section: String
    let banner: Banner
    let video: Bool
    var isFavourite: Bool = false
    
    static let emptyShopItem = ShopItem(id: "", name: "", description: "", type: "", images: [], firstReleaseDate: nil, previousReleaseDate: nil, expiryDate: nil,  buyAllowed: false, price: 0, regularPrice: 0, series: "", rarity: .common, granted: [], section: "", banner: .null, video: false)
    
    mutating func favouriteToggle() {
        isFavourite.toggle()
    }
    
    static func == (lhs: ShopItem, rhs: ShopItem) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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

struct GrantedItem {
    let id: String
    let typeID: String
    let type: String
    let name: String
    let description: String
    let rarity: Rarity?
    let series: String?
    let image: String
    let shareImage: String
    let video: String?
    
    static let emptyItem = {
        GrantedItem(id: "", typeID: "", type: "", name: "", description: "", rarity: .common, series: "", image: "", shareImage: "", video: "")
    }
    
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

struct ShopItemImage {
    let mode: String
    let image: String
    
    let emptyImage = {
        ShopItemImage(mode: "", image: "")
    }
    
    static func toItemImage(from item: ShopItemImageEntity) -> ShopItemImage {
        let mode = item.name ?? String()
        let image = item.image ?? String()
        
        return ShopItemImage(mode: mode, image: image)
    }
}

enum Banner {
    case null
    case new
    case sale
    case free
    case emote
    case pickaxe
}
