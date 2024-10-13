//
//  StatsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import Foundation

// MARK: - Stats

/// Represents the player's stats, including level, season, history, and other gameplay-related statistics
struct Stats {
    /// The name of the player
    let name: String
    /// The season number in which the stats are being tracked
    let season: Int?
    /// The current level of the player
    let level: Int
    /// The progress percentage of the player's current level
    let process: Int
    /// Boolean indicating if the result of the stats retrieval was successful
    let result: Bool
    /// Optional message describing the result
    let resultMessage: String?
    /// A history of the player's level progression over previous seasons
    let history: [LevelHistory]
    /// Global statistics broken down by specific game modes or categories
    let global: [String: SectionStats]
    /// Statistics broken down by input method (e.g., keyboard, controller)
    let input: [String: InputStats]
    
    /// A placeholder instance of `Stats` to represent an empty or error state
    static let emptyStats = Stats(name: Texts.StatsPage.placeholder, season: 0, level: 0, process: 0, result: true, resultMessage: nil, history: [], global: [:], input: [:])
    
    /// Sums up the total number of first-place finishes (topOne) across all global stats
    /// - Returns: The sum of topOne finishes as a `Double`
    internal func sumTopOne() -> Double {
        var result = 0
        for value in global.values {
            result += value.topOne
        }
        return Double(result)
    }
    
    /// Calculates the average kill-death ratio (KD) based on the specified input type
    /// - Parameter type: The input type to calculate the KD ratio for (`keyboard`, `controller` or `touch`)
    /// - Returns: The average KD ratio as a `Double`: returns 0 if there are no valid KD ratios
    internal func averageKD(type: SumType) -> Double {
        var sumKills = 0, sumDeaths: Double = 0
        var stats = [String : SectionStats]()
        switch type {
        case .global:
            stats = global
        case .keyboard:
            stats = input["keyboardmouse"]?.stats ?? [:]
        case .controller:
            stats = input["gamepad"]?.stats ?? [:]
        }
        for value in stats.values {
            if value.kd > 0 {
                sumKills += value.kills
                sumDeaths += (Double(value.kills) / Double(value.kd))
            }
        }
        guard sumDeaths > 0 else { return 0 }
        return Double(sumKills) / sumDeaths
    }
}

// MARK: - Level History

/// Represents the player's level progression history
struct LevelHistory {
    /// The season number associated with this history entry
    let season: Int
    /// The level reached during this season
    let level: Int
    /// The progress percentage of the player's level in the given season
    let progress: Int
    
    /// A placeholder instance of `LevelHistory` to represent an empty or error state
    static let emptyHistory = LevelHistory(season: 0, level: 0, progress: 0)
}

// MARK: - Section Stats

/// Represents statistics for a specific section or game mode (e.g., solo, duo, trio, squads)
struct SectionStats {
    /// The number of first-place finishes in this section
    let topOne: Int
    /// The kill-death ratio in this section
    let kd: Double
    /// The win rate percentage in this section
    let winrate: Double
    /// The number of times the player finished in the top three
    let topThree: Int
    /// The number of times the player finished in the top five
    let topFive: Int
    /// The number of times the player finished in the top six
    let topSix: Int
    /// The number of times the player finished in the top ten
    let topTen: Int
    /// The number of times the player finished in the top twelve
    let topTwelve: Int
    /// The number of times the player finished in the top twenty-five
    let topTwentyFive: Int
    /// The total number of kills
    let kills: Int
    /// The total number of matches played
    let matchesPlayed: Int
    /// The total time spent in this section, measured in minutes.
    let minutesPlayed: Int
    /// The total score achieved
    let score: Int
    /// The number of players outlived
    let playersOutlived: Int
    /// The last time the stats were modified, stored as a timestamp
    let lastModified: Int
    
    /// A placeholder instance of `SectionStats` to represent an empty or error state.
    static let emptyStats = SectionStats(topOne: 0, kd: 0, winrate: 0, topThree: 0, topFive: 0, topSix: 0, topTen: 0, topTwelve: 0, topTwentyFive: 0, kills: 0, matchesPlayed: 0, minutesPlayed: 0, score: 0, playersOutlived: 0, lastModified: 0)
}

// MARK: - Input Stats

/// Represents statistics based on input methods (e.g., keyboard, gamepad, touch)
struct InputStats {
    /// The input method (e.g., `keyboardmouse`, `gamepad`, `touch`)
    let input: String
    /// The statistics associated with the input method, broken down by game mode
    let stats: [String: SectionStats]
}

// MARK: - Enums

/// Defines the segments of stats, which can be titles, global stats, input-based stats, or history
enum StatsSegment {
    case title
    case global
    case input
    case history
}

/// Defines the types of stats summations that can be calculated
enum SumType {
    case global
    case keyboard
    case controller
}

/// Defines the types of cells in the stats view, either showing detailed stats or history
enum StatsCellType {
    case stats
    case history
}

/// Defines actions for managing input memory (e.g., saving or retrieving input stats)
enum InputMemoryManager {
    case get
    case save
}
