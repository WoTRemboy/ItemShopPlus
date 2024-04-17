//
//  StatsDetailsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

final class StatsDetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.StatsDetailsCell.identifier
    private var stats: SectionStats = SectionStats.emptyStats
    private var history: LevelHistory = LevelHistory.emptyHistory
    
    // MARK: - UI Elements and Views
    
    private let topWinrateMatches = StatsParameterView()
    private let kdKillsOutlived = StatsParameterView()
    private let hoursScore = StatsParameterView()
    private let historyRow = StatsParameterView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Public Configure Method
    
    public func configurate(stats: SectionStats, history: LevelHistory, type: StatsCellType) {
        backgroundColor = .BackColors.backStats
        layer.cornerRadius = 20
        
        self.stats = stats
        self.history = history
        switch type {
        case .stats:
            statsSetup()
        case .history:
            historySetup()
        }
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func statsSetup() {
        topWinrateMatches.configurate(
            firstTitle: Texts.StatsDetailsCell.winrate,
            firstContent: String(stats.winrate),
            secondTitle: Texts.StatsDetailsCell.topOne,
            secondContent: String(stats.topOne),
            thirdTitle: Texts.StatsDetailsCell.matches,
            thirdContent: String(stats.matchesPlayed), separator: false)
        
        kdKillsOutlived.configurate(
            firstTitle: Texts.StatsDetailsCell.kd,
            firstContent: String(stats.kd),
            secondTitle: Texts.StatsDetailsCell.kills,
            secondContent: String(stats.kills),
            thirdTitle: Texts.StatsDetailsCell.outlived,
            thirdContent: String(stats.playersOutlived))
        
        hoursScore.configurate(
            firstTitle: Texts.StatsDetailsCell.hours,
            firstContent: String(format: "%.2f", Double(stats.minutesPlayed) / 60.0),
            secondTitle: Texts.StatsDetailsCell.score,
            secondContent: String(stats.score))
        
        stackView.addArrangedSubview(topWinrateMatches)
        stackView.addArrangedSubview(kdKillsOutlived)
        stackView.addArrangedSubview(hoursScore)
        
        NSLayoutConstraint.activate([
            topWinrateMatches.heightAnchor.constraint(equalToConstant: 70),
            kdKillsOutlived.heightAnchor.constraint(equalToConstant: 70),
            hoursScore.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func historySetup() {
        historyRow.configurate(
            firstTitle: Texts.StatsDetailsCell.level,
            firstContent: String(history.level),
            secondTitle: Texts.StatsDetailsCell.progress,
            secondContent: String(history.progress),
            separator: false)
        stackView.addArrangedSubview(historyRow)
        
        NSLayoutConstraint.activate([
            historyRow.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupUI() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeFromSuperview()
    }
}
