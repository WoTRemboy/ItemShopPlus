//
//  JSONBundlesParseTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class BundleItemParsingTests: XCTestCase {

    /// Test parsing a valid JSON to BundleItem
    internal func testBundleItemParsingValidJSON() {
        let validJSON: [String: Any] = [
            "offerId": "bundle1",
            "available": true,
            "name": "Super Bundle",
            "description": "A great bundle.",
            "descriptionLong": "This bundle includes fantastic rewards.",
            "expiryDate": "2024-12-31 23:59:59Z",
            "keyImages": [
                ["type": "OfferImageTall", "url": "https://example.com/details.png"],
                ["type": "OfferImageWide", "url": "https://example.com/wide.png"]
            ],
            "thumbnail": "https://example.com/banner.png",
            "prices": [
                [
                    "paymentCurrencyCode": "USD",
                    "paymentCurrencySymbol": "$",
                    "paymentCurrencyAmountNatural": 9.99
                ]
            ],
            "granted": [
                ["templateId": "item1", "quantity": 1],
                ["templateId": "item2", "quantity": 2]
            ]
        ]
        
        if let bundleItem = BundleItem.sharingParse(sharingJSON: validJSON) {
            XCTAssertEqual(bundleItem.id, "bundle1")
            XCTAssertTrue(bundleItem.available)
            XCTAssertEqual(bundleItem.name, "Super Bundle")
            XCTAssertEqual(bundleItem.description, "A great bundle.")
            XCTAssertEqual(bundleItem.descriptionLong, "This bundle includes fantastic rewards.")
            XCTAssertEqual(bundleItem.detailsImage, "https://example.com/details.png")
            XCTAssertEqual(bundleItem.wideImage, "https://example.com/wide.png")
            XCTAssertEqual(bundleItem.bannerImage, "https://example.com/banner.png")
            
            // Test date parsing
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
            let expectedDate = dateFormatter.date(from: "2024-12-31 23:59:59Z")
            XCTAssertEqual(bundleItem.expiryDate, expectedDate)
            
            // Test prices parsing
            XCTAssertEqual(bundleItem.prices.count, 1)
            let price = bundleItem.prices.first
            XCTAssertEqual(price?.code, "USD")
            XCTAssertEqual(price?.symbol, "$")
            XCTAssertEqual(price?.price, 9.99)
            
            // Test granted items parsing
            XCTAssertEqual(bundleItem.granted.count, 2)
            XCTAssertEqual(bundleItem.granted[0].id, "item1")
            XCTAssertEqual(bundleItem.granted[0].quantity, 1)
            XCTAssertEqual(bundleItem.granted[1].id, "item2")
            XCTAssertEqual(bundleItem.granted[1].quantity, 2)
        } else {
            XCTFail("Failed to parse valid JSON.")
        }
    }

    /// Test parsing an invalid JSON (missing required fields)
    internal func testBundleItemParsingInvalidJSON() {
        let invalidJSON: [String: Any] = [
            "offerId": "bundle1",
            "available": false, // Bundle should be unavailable, hence parsing should fail
            "name": "Super Bundle"
        ]
        
        let bundleItem = BundleItem.sharingParse(sharingJSON: invalidJSON)
        XCTAssertNil(bundleItem, "Expected parsing to fail for unavailable bundle.")
    }

    /// Test BundleGranted parsing valid JSON
    internal func testBundleGrantedParsingValidJSON() {
        let validGrantedJSON: [String: Any] = [
            "templateId": "item1",
            "quantity": 1
        ]
        
        if let grantedItem = BundleGranted.sharingParse(sharingJSON: validGrantedJSON) {
            XCTAssertEqual(grantedItem.id, "item1")
            XCTAssertEqual(grantedItem.quantity, 1)
        } else {
            XCTFail("Failed to parse valid granted item JSON.")
        }
    }

    /// Test BundleGranted parsing invalid JSON (missing fields)
    internal func testBundleGrantedParsingInvalidJSON() {
        let invalidGrantedJSON: [String: Any] = [
            "templateId": "item1"
            // Missing "quantity"
        ]
        
        let grantedItem = BundleGranted.sharingParse(sharingJSON: invalidGrantedJSON)
        XCTAssertNil(grantedItem, "Expected parsing to fail due to missing quantity.")
    }

    /// Test BundleItem parsing with missing fields in JSON
    internal func testBundleItemParsingWithMissingFields() {
        let missingFieldsJSON: [String: Any] = [
            "offerId": "bundle1",
            "available": true,
            "name": "Incomplete Bundle",
            "keyImages": [],
            "prices": [],
            "granted": []
        ]
        
        if let bundleItem = BundleItem.sharingParse(sharingJSON: missingFieldsJSON) {
            XCTAssertEqual(bundleItem.id, "bundle1")
            XCTAssertEqual(bundleItem.name, "Incomplete Bundle")
            XCTAssertTrue(bundleItem.prices.isEmpty)
            XCTAssertTrue(bundleItem.granted.isEmpty)
        } else {
            XCTFail("Failed to parse JSON with missing optional fields.")
        }
    }
}
