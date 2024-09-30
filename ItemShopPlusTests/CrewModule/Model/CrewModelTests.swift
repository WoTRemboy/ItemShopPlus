//
//  CrewModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class CrewModelTests: XCTestCase {
    
    // Test CrewPack creation with valid data
    internal func testCrewPackCreation() {
        // Create sample CrewItem and CrewPrice data
        let crewItem = CrewItem(id: "item1", type: "Skin", name: "Crew Skin", description: "Exclusive skin", rarity: .legendary, image: "https://example.com/item.png", shareImage: "https://example.com/share.png", introduction: "Chapter 2", video: true)
        
        let crewPrice = CrewPrice(type: .usd, code: "USD", symbol: "$", price: 11.99)
        
        // Create a CrewPack with sample data
        let crewPack = CrewPack(title: "Crew Pack February", items: [crewItem], battlePassTitle: "Season Pass", addPassTitle: "Bonus Pass", image: "https://example.com/pack.png", date: "2024-02-25", price: [crewPrice])
        
        // Assertions to verify CrewPack properties
        XCTAssertNotNil(crewPack)
        XCTAssertEqual(crewPack.title, "Crew Pack February")
        XCTAssertEqual(crewPack.items.count, 1)
        XCTAssertEqual(crewPack.battlePassTitle, "Season Pass")
        XCTAssertEqual(crewPack.addPassTitle, "Bonus Pass")
        XCTAssertEqual(crewPack.image, "https://example.com/pack.png")
        XCTAssertEqual(crewPack.date, "2024-02-25")
        XCTAssertEqual(crewPack.price.count, 1)
        XCTAssertEqual(crewPack.vbucks, 1000) // Default value
    }
    
    // Test CrewItem creation and attributes
    internal func testCrewItemCreation() {
        // Create a sample CrewItem
        let crewItem = CrewItem(id: "item2", type: "Back Bling", name: "Crew Back Bling", description: "Exclusive back bling", rarity: .epic, image: "https://example.com/item2.png", shareImage: "https://example.com/share2.png", introduction: "Chapter 3", video: false)
        
        // Assertions to verify CrewItem properties
        XCTAssertNotNil(crewItem)
        XCTAssertEqual(crewItem.id, "item2")
        XCTAssertEqual(crewItem.type, "Back Bling")
        XCTAssertEqual(crewItem.name, "Crew Back Bling")
        XCTAssertEqual(crewItem.description, "Exclusive back bling")
        XCTAssertEqual(crewItem.rarity, .epic)
        XCTAssertEqual(crewItem.image, "https://example.com/item2.png")
        XCTAssertEqual(crewItem.shareImage, "https://example.com/share2.png")
        XCTAssertEqual(crewItem.introduction, "Chapter 3")
        XCTAssertFalse(crewItem.video)
    }
    
    // Test CrewPrice creation and attributes
    internal func testCrewPriceCreation() {
        // Create a sample CrewPrice
        let crewPrice = CrewPrice(type: .eur, code: "EUR", symbol: "€", price: 9.99)
        
        // Assertions to verify CrewPrice properties
        XCTAssertNotNil(crewPrice)
        XCTAssertEqual(crewPrice.type, .eur)
        XCTAssertEqual(crewPrice.code, "EUR")
        XCTAssertEqual(crewPrice.symbol, "€")
        XCTAssertEqual(crewPrice.price, 9.99)
    }
    
    // Test the emptyPack constant
    internal func testEmptyCrewPack() {
        // Verify that the emptyPack is correctly initialized
        let emptyPack = CrewPack.emptyPack
        
        XCTAssertEqual(emptyPack.title, "")
        XCTAssertTrue(emptyPack.items.isEmpty)
        XCTAssertNil(emptyPack.battlePassTitle)
        XCTAssertNil(emptyPack.addPassTitle)
        XCTAssertNil(emptyPack.image)
        XCTAssertEqual(emptyPack.date, "")
        XCTAssertEqual(emptyPack.price.count, 1)
        XCTAssertEqual(emptyPack.price.first?.price, -5) // Default empty price
    }
    
    // Test the emptyPrice constant
    internal func testEmptyCrewPrice() {
        // Verify that the emptyPrice is correctly initialized
        let emptyPrice = CrewPrice.emptyPrice
        
        XCTAssertEqual(emptyPrice.type, .usd)
        XCTAssertEqual(emptyPrice.code, Texts.Currency.Code.usd)
        XCTAssertEqual(emptyPrice.symbol, Texts.Currency.Symbol.usd)
        XCTAssertEqual(emptyPrice.price, -5)
    }
}
