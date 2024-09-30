//
//  JSONMapParseTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class JSONMapParseTests: XCTestCase {

    // Test for successful parsing of a valid JSON
    internal func testMapParsingValid() {
        // Create a valid JSON dictionary
        let json: [String: Any] = [
            "patchVersion": "v1.0.1",
            "releaseDate": "2024-09-30",
            "url": "https://example.com/map_clear.png",
            "urlPOI": "https://example.com/map_poi.png"
        ]
        
        // Parse the JSON using the sharingParse method
        let parsedMap = Map.sharingParse(sharingJSON: json)
        
        // Check if the parsed map has the correct values
        XCTAssertNotNil(parsedMap, "Parsing should succeed for valid JSON")
        XCTAssertEqual(parsedMap?.patchVersion, "v1.0.1")
        XCTAssertEqual(parsedMap?.clearImage, "https://example.com/map_clear.png")
        XCTAssertEqual(parsedMap?.poiImage, "https://example.com/map_poi.png")
        
        // Check if the release date is correctly parsed
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedDate = dateFormatter.date(from: "2024-09-30")
        XCTAssertEqual(parsedMap?.realeseDate, expectedDate)
    }

    // Test for missing or invalid data
    internal func testMapParsingInvalid() {
        // Create an invalid JSON dictionary (missing required fields)
        let json: [String: Any] = [
            "patchVersion": "v1.0.1",
            "releaseDate": "invalid_date",  // Invalid date format
            "url": "https://example.com/map_clear.png"
            // Missing 'urlPOI' field
        ]
        
        // Parse the JSON using the sharingParse method
        let parsedMap = Map.sharingParse(sharingJSON: json)
        
        // Check that the parsing returns nil due to missing or invalid data
        XCTAssertNil(parsedMap, "Parsing should fail when required data is missing or invalid")
    }
    
    // Test for invalid date format
    internal func testMapParsingInvalidDateFormat() {
        // Create a JSON dictionary with an invalid date format
        let json: [String: Any] = [
            "patchVersion": "v1.0.1",
            "releaseDate": "30-09-2024",  // Wrong date format
            "url": "https://example.com/map_clear.png",
            "urlPOI": "https://example.com/map_poi.png"
        ]
        
        // Parse the JSON using the sharingParse method
        let parsedMap = Map.sharingParse(sharingJSON: json)
        
        // Check that the date falls back to the current date
        XCTAssertNotNil(parsedMap, "Parsing should succeed even with an invalid date format")
        XCTAssertEqual(parsedMap?.patchVersion, "v1.0.1")
        XCTAssertEqual(parsedMap?.clearImage, "https://example.com/map_clear.png")
        XCTAssertEqual(parsedMap?.poiImage, "https://example.com/map_poi.png")
    }
}
