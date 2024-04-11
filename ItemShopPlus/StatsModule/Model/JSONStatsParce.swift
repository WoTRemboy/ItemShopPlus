//
//  JSONStatsParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import Foundation

extension Stats {
    static func sharingParse(sharingJSON: Any) -> Stats? {
        guard let globalData = sharingJSON as? [String: Any],
              let name = globalData["name"] as? String,
              let accountData = globalData["account"] as? [String: Any],
              let historyData = globalData["accountLevelHistory"] as? [[String: Any]],
              let allStatsData = globalData["global_stats"] as? [String: Any],
              let inputData = globalData["per_input"] as? [String: Any],
              let level = accountData["level"] as? Int
        else {
            return nil
        }
        
        let season = accountData["season"] as? Int
        let process = accountData["process_pct"] as? Int ?? 0
        let history = historyData.compactMap { LevelHistory.sharingParce(sharingJSON: $0) }
        
        var global = [String: SectionStats]()
        for statsDatum in allStatsData {
            let stat = SectionStats.sharingParce(sharingJSON: statsDatum.value)
            global[statsDatum.key] = stat
        }
        
        var inputs = [String: InputStats]()
        for inputDatum in inputData {
            if let modes = inputDatum.value as? [String: Any] {
                let inputStat = InputStats.sharingParce(input: inputDatum.key, sharingJSON: modes)
                inputs[inputDatum.key] = inputStat
            }
        }
        
        return Stats(name: name, season: season, level: level, process: process, history: history, global: global, input: inputs)
    }
}

extension LevelHistory {
    static func sharingParce(sharingJSON: Any) -> LevelHistory? {
        guard let globalData = sharingJSON as? [String: Any],
              let season = globalData["season"] as? Int,
              let level = globalData["level"] as? Int,
              let process = globalData["process_pct"] as? Int
        else {
            return nil
        }
        return LevelHistory(season: season, level: level, progress: process)
    }
}

extension SectionStats {
    static func sharingParce(sharingJSON: Any) -> SectionStats? {
        guard let globalData = sharingJSON as? [String: Any],
              let topOne = globalData["placetop1"] as? Int,
              let kd = globalData["kd"] as? Double,
              let winrate = globalData["winrate"] as? Double,
              let topThree = globalData["placetop3"] as? Int,
              let topFive = globalData["placetop5"] as? Int,
              let topSix = globalData["placetop6"] as? Int,
              let topTen = globalData["placetop10"] as? Int,
              let topTwelve = globalData["placetop12"] as? Int,
              let topTwentyFive = globalData["placetop25"] as? Int,
              let kills = globalData["kills"] as? Int,
              let matchesplayed = globalData["matchesplayed"] as? Int,
              let minutesplayed = globalData["minutesplayed"] as? Int,
              let score = globalData["score"] as? Int,
              let playersoutlived = globalData["playersoutlived"] as? Int,
              let lastModified = globalData["lastmodified"] as? Int
        else {
            return nil
        }
        return SectionStats(topOne: topOne, kd: kd, winrate: winrate, topThree: topThree, topFive: topFive, topSix: topSix, topTen: topTen, topTwelve: topTwelve, topTwentyFive: topTwentyFive, kills: kills, matchesPlayed: matchesplayed, minutesPlayed: minutesplayed, score: score, playersOutlived: playersoutlived, lastModified: lastModified)
    }
}

extension InputStats {
    static func sharingParce(input: String, sharingJSON: Any) -> InputStats? {
        guard let globalData = sharingJSON as? [String: Any]
        else {
            return nil
        }
        var stats = [String: SectionStats]()
        for globalDatum in globalData {
            let stat = SectionStats.sharingParce(sharingJSON: globalDatum.value)
            stats[globalDatum.key] = stat
        }
        return InputStats(input: input, stats: stats)
    }
}
