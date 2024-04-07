//
//  StatsModel.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import Foundation

struct Stats {
    let name: String
    let season: Int?
    let level: Int
    let process: Int
    let history: [LevelHistory]
    let global: [String: SectionStats]
    let input: [String: InputStats]
    
    static let emptyStats = Stats(name: "Error", season: 0, level: 0, process: 0, history: [], global: [:], input: [:])
}

struct LevelHistory {
    let season: Int
    let level: Int
    let progress: Int
}

struct SectionStats {
    let topOne: Int
    let kd: Double
    let winrate: Double
    let topThree: Int
    let topFive: Int
    let topSix: Int
    let topTen: Int
    let topTwelve: Int
    let topTwentyFive: Int
    let kills: Int
    let matchesPlayed: Int
    let minutesPlayed: Int
    let score: Int
    let playersOutlived: Int
    let lastModified: Int
}

struct InputStats {
    let input: String
    let stats: [String: SectionStats]
}
