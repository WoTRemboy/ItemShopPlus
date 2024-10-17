//
//  ItemVideoModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class ItemVideoModelTests: XCTestCase {

    /// Test for ItemVideo.emptyVideo
    internal func testEmptyVideo() {
        // Check if emptyVideo has the expected default values
        let emptyVideo = ItemVideo.emptyVideo
        XCTAssertEqual(emptyVideo.id, "")
        XCTAssertEqual(emptyVideo.video, "")
    }
    
    /// Test for ItemVideo.sharingParse with valid JSON input
    internal func testSharingParseWithValidJSON() {
        // Prepare a valid JSON input
        let validJSON: [String: Any] = [
            "id": "12345",
            "previewVideos": [
                ["url": "https://example.com/video.mp4"]
            ]
        ]
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: validJSON)
        
        // Ensure the parsed values are correct
        XCTAssertNotNil(itemVideo, "ItemVideo should not be nil for valid JSON.")
        XCTAssertEqual(itemVideo?.id, "12345")
        XCTAssertEqual(itemVideo?.video, "https://example.com/video.mp4")
    }
    
    /// Test for ItemVideo.sharingParse with missing 'id' field
    internal func testSharingParseWithMissingID() {
        // Prepare a JSON input with a missing 'id' field
        let invalidJSON: [String: Any] = [
            "previewVideos": [
                ["url": "https://example.com/video.mp4"]
            ]
        ]
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: invalidJSON)
        
        // Ensure the result is nil due to missing 'id'
        XCTAssertNil(itemVideo, "ItemVideo should be nil when 'id' field is missing.")
    }
    
    /// Test for ItemVideo.sharingParse with missing 'previewVideos' field
    internal func testSharingParseWithMissingPreviewVideos() {
        // Prepare a JSON input with a missing 'previewVideos' field
        let invalidJSON: [String: Any] = [
            "id": "12345"
        ]
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: invalidJSON)
        
        // Ensure the result is nil due to missing 'previewVideos'
        XCTAssertNil(itemVideo, "ItemVideo should be nil when 'previewVideos' field is missing.")
    }
    
    /// Test for ItemVideo.sharingParse with empty 'previewVideos' array
    internal func testSharingParseWithEmptyPreviewVideos() {
        // Prepare a JSON input with an empty 'previewVideos' array
        let invalidJSON: [String: Any] = [
            "id": "12345",
            "previewVideos": []
        ]
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: invalidJSON)
        
        // Ensure the result is nil due to an empty 'previewVideos' array
        XCTAssertNil(itemVideo, "ItemVideo should be nil when 'previewVideos' array is empty.")
    }
    
    /// Test for ItemVideo.sharingParse with missing 'url' field in previewVideos
    internal func testSharingParseWithMissingURLInPreviewVideos() {
        // Prepare a JSON input where the 'url' field in 'previewVideos' is missing
        let invalidJSON: [String: Any] = [
            "id": "12345",
            "previewVideos": [
                ["title": "Example video"] // Missing 'url' field
            ]
        ]
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: invalidJSON)
        
        // Ensure the result is nil due to missing 'url' field
        XCTAssertNil(itemVideo, "ItemVideo should be nil when 'url' field is missing in 'previewVideos'.")
    }

    /// Test for ItemVideo.sharingParse with non-dictionary JSON input
    internal func testSharingParseWithNonDictionaryInput() {
        // Prepare a non-dictionary JSON input (invalid format)
        let invalidJSON = "Invalid format"
        
        // Call the sharingParse function
        let itemVideo = ItemVideo.sharingParse(sharingJSON: invalidJSON)
        
        // Ensure the result is nil due to invalid input format
        XCTAssertNil(itemVideo, "ItemVideo should be nil for non-dictionary JSON input.")
    }
}
