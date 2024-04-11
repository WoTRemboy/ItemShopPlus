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
    
    internal func sumTopOne() -> Double {
        var result = 0
        for value in global.values {
            result += value.topOne
        }
        return Double(result)
    }
    
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

enum StatsSegment {
    case title
    case global
    case input
    case history
}

enum SumType {
    case global
    case keyboard
    case controller
}
