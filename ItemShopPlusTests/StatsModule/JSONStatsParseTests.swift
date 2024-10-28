//
//  JSONStatsParseTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class StatsParsingTests: XCTestCase {
    
    /// Test parsing Stats with valid JSON
    internal func testParseValidStatsJSON() {
        let json: [String: Any] = [
            "result": true,
            "name": "Player1",
            "account": ["season": 3, "level": 45, "process_pct": 80],
            "global_stats": [
                "mode1": [
                    "placetop1": 10,
                    "kd": 2.5,
                    "winrate": 50.0,
                    "placetop3": 5,
                    "placetop5": 8,
                    "placetop6": 12,
                    "placetop10": 15,
                    "placetop12": 20,
                    "placetop25": 25,
                    "kills": 200,
                    "matchesplayed": 100,
                    "minutesplayed": 3000,
                    "score": 5000,
                    "playersoutlived": 1500,
                    "lastmodified": 123456789
                ]
            ],
            "per_input": [
                "keyboardmouse": [
                    "mode1": [
                        "placetop1": 5,
                        "kd": 1.8,
                        "winrate": 45.0,
                        "placetop3": 4,
                        "placetop5": 7,
                        "placetop6": 10,
                        "placetop10": 13,
                        "placetop12": 17,
                        "placetop25": 22,
                        "kills": 120,
                        "matchesplayed": 60,
                        "minutesplayed": 1800,
                        "score": 3000,
                        "playersoutlived": 1000,
                        "lastmodified": 987654321
                    ]
                ]
            ],
            "accountLevelHistory": [
                ["season": 2, "level": 30, "process_pct": 60]
            ]
        ]
        
        let stats = Stats.sharingParse(sharingJSON: json)
        
        XCTAssertNotNil(stats, "Stats should be parsed successfully")
        XCTAssertEqual(stats?.name, "Player1")
        XCTAssertEqual(stats?.level, 45)
        XCTAssertEqual(stats?.process, 80)
        XCTAssertEqual(stats?.result, true)
        XCTAssertEqual(stats?.history.first?.season, 2)
        XCTAssertEqual(stats?.history.first?.level, 30)
        XCTAssertEqual(stats?.history.first?.progress, 60)
    }
    
    // Test parsing Stats with missing or invalid fields
    internal func testParseInvalidStatsJSON() {
        let json: [String: Any] = [
            "result": true,
            "name": "Player1",
            "account": ["season": 3, "level": 45],
            "global_stats": [
                "mode1": [
                    "placetop1": 10,
                    "kd": "invalid", // Invalid kd value
                    "winrate": 50.0
                ]
            ]
        ]
        
        let stats = Stats.sharingParse(sharingJSON: json)
        
        XCTAssertNotNil(stats, "Stats should be parsed even with invalid fields")
        XCTAssertEqual(stats?.name, "Player1")
        XCTAssertNil(stats?.global["mode1"]?.kd, "KD should be nil due to invalid value")
    }
    
    /// Test parsing with minimal JSON structure
    internal func testParseMinimalValidJSON() {
        let json: [String: Any] = [
            "result": true,
            "name": "Player1",
            "global_stats": [:]
        ]
        
        let stats = Stats.sharingParse(sharingJSON: json)
        
        XCTAssertNotNil(stats, "Stats should be parsed successfully with minimal JSON")
        XCTAssertEqual(stats?.name, "Player1")
        XCTAssertTrue(stats?.global.isEmpty ?? false, "Global stats should be empty")
    }
    
    /// Test parsing LevelHistory with valid data
    internal func testParseLevelHistoryValidJSON() {
        let historyJSON: [String: Any] = [
            "season": 2,
            "level": 30,
            "process_pct": 60
        ]
        
        let history = LevelHistory.sharingParce(sharingJSON: historyJSON)
        
        XCTAssertNotNil(history, "LevelHistory should be parsed successfully")
        XCTAssertEqual(history?.season, 2)
        XCTAssertEqual(history?.level, 30)
        XCTAssertEqual(history?.progress, 60)
    }
    
    /// Test parsing SectionStats with valid data
    internal func testParseSectionStatsValidJSON() {
        let sectionJSON: [String: Any] = [
            "placetop1": 10,
            "kd": 2.5,
            "winrate": 50.0,
            "placetop3": 5,
            "placetop5": 8,
            "placetop6": 12,
            "placetop10": 15,
            "placetop12": 20,
            "placetop25": 25,
            "kills": 200,
            "matchesplayed": 100,
            "minutesplayed": 3000,
            "score": 5000,
            "playersoutlived": 1500,
            "lastmodified": 123456789
        ]
        
        let sectionStats = SectionStats.sharingParce(sharingJSON: sectionJSON)
        
        XCTAssertNotNil(sectionStats, "SectionStats should be parsed successfully")
        XCTAssertEqual(sectionStats?.topOne, 10)
        XCTAssertEqual(sectionStats?.kd, 2.5)
        XCTAssertEqual(sectionStats?.winrate, 50.0)
        XCTAssertEqual(sectionStats?.kills, 200)
    }
    
    /// Test parsing InputStats with valid data
    internal func testParseInputStatsValidJSON() {
        let inputJSON: [String: Any] = [
            "mode1": [
                "placetop1": 5,
                "kd": 1.8,
                "winrate": 45.0,
                "placetop3": 4,
                "placetop5": 7,
                "placetop6": 10,
                "placetop10": 13,
                "placetop12": 17,
                "placetop25": 22,
                "kills": 120,
                "matchesplayed": 60,
                "minutesplayed": 1800,
                "score": 3000,
                "playersoutlived": 1000,
                "lastmodified": 987654321
            ]
        ]
        
        let inputStats = InputStats.sharingParce(input: "keyboardmouse", sharingJSON: inputJSON)
        
        XCTAssertNotNil(inputStats, "InputStats should be parsed successfully")
        XCTAssertEqual(inputStats?.input, "keyboardmouse")
    }
}
