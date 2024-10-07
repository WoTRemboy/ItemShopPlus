//
//  BundlesModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class BundleItemTests: XCTestCase {

    // Test initializing BundleItem with all properties
    internal func testBundleItemInitialization() {
        let expiryDate = Date()
        let prices = [BundlePrice(type: .usd, code: "USD", symbol: "$", price: 9.99)]
        let grantedItems = [BundleGranted(id: "item1", quantity: 1)]
        
        let bundleItem = BundleItem(
            id: "bundle1",
            available: true,
            name: "Special Bundle",
            description: "This is a special bundle.",
            descriptionLong: "This bundle includes exclusive items.",
            detailsImage: "https://example.com/details.png",
            bannerImage: "https://example.com/banner.png",
            wideImage: "https://example.com/wide.png",
            expiryDate: expiryDate,
            prices: prices,
            granted: grantedItems
        )
        
        // Verify BundleItem properties
        XCTAssertEqual(bundleItem.id, "bundle1")
        XCTAssertTrue(bundleItem.available)
        XCTAssertEqual(bundleItem.name, "Special Bundle")
        XCTAssertEqual(bundleItem.description, "This is a special bundle.")
        XCTAssertEqual(bundleItem.descriptionLong, "This bundle includes exclusive items.")
        XCTAssertEqual(bundleItem.detailsImage, "https://example.com/details.png")
        XCTAssertEqual(bundleItem.bannerImage, "https://example.com/banner.png")
        XCTAssertEqual(bundleItem.wideImage, "https://example.com/wide.png")
        XCTAssertEqual(bundleItem.expiryDate, expiryDate)
        XCTAssertEqual(bundleItem.prices.count, 1)
        XCTAssertEqual(bundleItem.prices.first?.price, 9.99)
        XCTAssertEqual(bundleItem.granted.count, 1)
        XCTAssertEqual(bundleItem.granted.first?.id, "item1")
        XCTAssertEqual(bundleItem.granted.first?.quantity, 1)
        XCTAssertEqual(bundleItem.currency, .usd)
    }

    // Test BundleItem empty state
    internal func testBundleItemEmpty() {
        let emptyBundle = BundleItem.emptyBundle
        
        // Verify that empty bundle has default empty values
        XCTAssertEqual(emptyBundle.id, "")
        XCTAssertFalse(emptyBundle.available)
        XCTAssertEqual(emptyBundle.name, "")
        XCTAssertEqual(emptyBundle.description, "")
        XCTAssertEqual(emptyBundle.descriptionLong, "")
        XCTAssertEqual(emptyBundle.detailsImage, "")
        XCTAssertEqual(emptyBundle.bannerImage, "")
        XCTAssertEqual(emptyBundle.wideImage, "")
        XCTAssertNotNil(emptyBundle.expiryDate)
        XCTAssertTrue(emptyBundle.prices.isEmpty)
        XCTAssertTrue(emptyBundle.granted.isEmpty)
        XCTAssertEqual(emptyBundle.currency, .usd)
    }

    // Test initializing BundlePrice
    internal func testBundlePriceInitialization() {
        let price = BundlePrice(type: .usd, code: "USD", symbol: "$", price: 19.99)
        
        // Verify BundlePrice properties
        XCTAssertEqual(price.type, .usd)
        XCTAssertEqual(price.code, "USD")
        XCTAssertEqual(price.symbol, "$")
        XCTAssertEqual(price.price, 19.99)
    }

    // Test BundlePrice empty state
    internal func testBundlePriceEmpty() {
        let emptyPrice = BundlePrice.emptyPrice
        
        // Verify that empty price has default values
        XCTAssertEqual(emptyPrice.type, .usd)
        XCTAssertEqual(emptyPrice.code, "USD")
        XCTAssertEqual(emptyPrice.symbol, "$")
        XCTAssertEqual(emptyPrice.price, -5)
    }

    // Test initializing BundleGranted
    internal func testBundleGrantedInitialization() {
        let grantedItem = BundleGranted(id: "granted1", quantity: 3)
        
        // Verify BundleGranted properties
        XCTAssertEqual(grantedItem.id, "granted1")
        XCTAssertEqual(grantedItem.quantity, 3)
    }

    // Test BundleItem with multiple prices and granted items
    internal func testBundleItemWithMultiplePricesAndGrantedItems() {
        let prices = [
            BundlePrice(type: .usd, code: "USD", symbol: "$", price: 19.99),
            BundlePrice(type: .eur, code: "EUR", symbol: "€", price: 17.99)
        ]
        let grantedItems = [
            BundleGranted(id: "item1", quantity: 1),
            BundleGranted(id: "item2", quantity: 2)
        ]
        
        let bundleItem = BundleItem(
            id: "bundle2",
            available: true,
            name: "Deluxe Bundle",
            description: "This is a deluxe bundle.",
            descriptionLong: "Includes several exclusive items.",
            detailsImage: "https://example.com/details.png",
            bannerImage: "https://example.com/banner.png",
            wideImage: "https://example.com/wide.png",
            expiryDate: .now,
            prices: prices,
            granted: grantedItems
        )
        
        // Verify properties
        XCTAssertEqual(bundleItem.id, "bundle2")
        XCTAssertEqual(bundleItem.prices.count, 2)
        XCTAssertEqual(bundleItem.prices[0].price, 19.99)
        XCTAssertEqual(bundleItem.prices[1].price, 17.99)
        XCTAssertEqual(bundleItem.granted.count, 2)
        XCTAssertEqual(bundleItem.granted[0].id, "item1")
        XCTAssertEqual(bundleItem.granted[1].quantity, 2)
    }
}
