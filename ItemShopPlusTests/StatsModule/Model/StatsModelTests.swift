//
//  StatsModelTests.swift
//  ItemShopPlusTests
//
//  Created by Roman Tverdokhleb on 9/30/24.
//

import XCTest
@testable import ItemShopPlus

final class StatsTests: XCTestCase {
    
    // Test for sumTopOne() method
    internal func testSumTopOne() {
        let globalStats: [String: SectionStats] = [
            "mode1": SectionStats(topOne: 3, kd: 2.0, winrate: 50.0, topThree: 5, topFive: 10, topSix: 12, topTen: 15, topTwelve: 20, topTwentyFive: 25, kills: 50, matchesPlayed: 30, minutesPlayed: 1000, score: 1500, playersOutlived: 200, lastModified: 123456789),
            "mode2": SectionStats(topOne: 7, kd: 3.5, winrate: 60.0, topThree: 8, topFive: 15, topSix: 18, topTen: 25, topTwelve: 30, topTwentyFive: 40, kills: 80, matchesPlayed: 50, minutesPlayed: 2000, score: 2500, playersOutlived: 400, lastModified: 987654321)
        ]
        
        let stats = Stats(name: "Player1", season: 3, level: 25, process: 50, result: true, resultMessage: nil, history: [], global: globalStats, input: [:])
        
        let sumTopOne = stats.sumTopOne()
        XCTAssertEqual(sumTopOne, 10.0, "Expected sum of topOne to be 10")
    }
    
    // Test for averageKD() method with global stats
    internal func testAverageKDGlobal() {
        let globalStats: [String: SectionStats] = [
            "mode1": SectionStats(topOne: 3, kd: 2.0, winrate: 50.0, topThree: 5, topFive: 10, topSix: 12, topTen: 15, topTwelve: 20, topTwentyFive: 25, kills: 50, matchesPlayed: 30, minutesPlayed: 1000, score: 1500, playersOutlived: 200, lastModified: 123456789),
            "mode2": SectionStats(topOne: 7, kd: 3.5, winrate: 60.0, topThree: 8, topFive: 15, topSix: 18, topTen: 25, topTwelve: 30, topTwentyFive: 40, kills: 80, matchesPlayed: 50, minutesPlayed: 2000, score: 2500, playersOutlived: 400, lastModified: 987654321)
        ]
        
        let stats = Stats(name: "Player1", season: 3, level: 25, process: 50, result: true, resultMessage: nil, history: [], global: globalStats, input: [:])
        
        let averageKD = stats.averageKD(type: .global)
        XCTAssertEqual(averageKD, 2.7164, accuracy: 0.0001, "Expected average KD to be close to 2.7778")
    }
    
    // Test for averageKD() method with keyboard input stats
    internal func testAverageKDKeyboard() {
        let inputStats: [String: SectionStats] = [
            "keyboardmouse": SectionStats(topOne: 3, kd: 4.0, winrate: 55.0, topThree: 5, topFive: 12, topSix: 14, topTen: 20, topTwelve: 22, topTwentyFive: 30, kills: 100, matchesPlayed: 60, minutesPlayed: 1500, score: 2200, playersOutlived: 350, lastModified: 135792468)
        ]
        
        let keyboardInput = InputStats(input: "keyboardmouse", stats: inputStats)
        
        let stats = Stats(name: "Player2", season: 4, level: 30, process: 70, result: true, resultMessage: "Victory!", history: [], global: [:], input: ["keyboardmouse": keyboardInput])
        
        let averageKD = stats.averageKD(type: .keyboard)
        XCTAssertEqual(averageKD, 4.0, "Expected average KD for keyboard input to be 4.0")
    }
    
    // Test for empty stats
    internal func testEmptyStats() {
        let emptyStats = Stats.emptyStats
        
        XCTAssertEqual(emptyStats.name, Texts.StatsPage.placeholder)
        XCTAssertEqual(emptyStats.season, 0)
        XCTAssertEqual(emptyStats.level, 0)
        XCTAssertEqual(emptyStats.process, 0)
        XCTAssertTrue(emptyStats.result)
        XCTAssertNil(emptyStats.resultMessage)
        XCTAssertTrue(emptyStats.history.isEmpty)
        XCTAssertTrue(emptyStats.global.isEmpty)
        XCTAssertTrue(emptyStats.input.isEmpty)
    }
    
    // Test for LevelHistory data
    internal func testLevelHistory() {
        let history = LevelHistory(season: 3, level: 45, progress: 75)
        XCTAssertEqual(history.season, 3)
        XCTAssertEqual(history.level, 45)
        XCTAssertEqual(history.progress, 75)
    }
    
    // Test for SectionStats data
    internal func testSectionStats() {
        let sectionStats = SectionStats(topOne: 2, kd: 1.5, winrate: 50.0, topThree: 4, topFive: 6, topSix: 8, topTen: 10, topTwelve: 12, topTwentyFive: 15, kills: 20, matchesPlayed: 25, minutesPlayed: 500, score: 1000, playersOutlived: 300, lastModified: 123456789)
        
        XCTAssertEqual(sectionStats.topOne, 2)
        XCTAssertEqual(sectionStats.kd, 1.5)
        XCTAssertEqual(sectionStats.winrate, 50.0)
        XCTAssertEqual(sectionStats.kills, 20)
        XCTAssertEqual(sectionStats.matchesPlayed, 25)
        XCTAssertEqual(sectionStats.minutesPlayed, 500)
        XCTAssertEqual(sectionStats.score, 1000)
        XCTAssertEqual(sectionStats.playersOutlived, 300)
        XCTAssertEqual(sectionStats.lastModified, 123456789)
    }
}
