//
//  StatsDetailsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

/// A custom collection view cell used to display detailed statistics or historical level data for the user
final class StatsDetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The identifier used to register and dequeue the cell in a collection view.
    static let identifier = Texts.StatsDetailsCell.identifier
    /// A variable that stores the `SectionStats` containing detailed player statistics
    private var stats: SectionStats = SectionStats.emptyStats
    /// A variable that stores the `LevelHistory` representing the player's level history
    private var history: LevelHistory = LevelHistory.emptyHistory
    
    /// A computed property that fetches the current language setting for the app
    private var appLanguage: String {
        if let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            if let currentLang = userDefault.string(forKey: Texts.LanguageSave.userDefaultsKey) {
                return currentLang
            }
        }
        return Texts.NetworkRequest.language
    }
    
    // MARK: - UI Elements and Views
    
    /// A row view to display the player's top finishes, winrate, and match count
    private let topWinrateMatches = StatsParameterView()
    /// A row view to display the player's kill-death ratio, kills, and players outlived
    private let kdKillsOutlived = StatsParameterView()
    /// A row view to show the player's total hours played and score
    private let hoursScore = StatsParameterView()
    /// A row view to show historical level and progress
    private let historyRow = StatsParameterView()
    
    /// A stack view that arranges the parameter views vertically
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell to display data based on the provided `StatsCellType`
    /// - Parameters:
    ///   - stats: `SectionStats` object containing the detailed stats of the player
    ///   - history: `LevelHistory` object containing the player's level history
    ///   - type: `StatsCellType` enum that determines whether to display statistics or history in the cell
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
    
    // MARK: - Texts Configuration Methods
    
    /// Formats a percentage string based on the user's app language settings
    /// - Parameter content: The integer value representing a percentage
    /// - Returns: A formatted percentage string in the correct language format
    private func definePercentage(content: Int) -> String {
        switch appLanguage {
        case "tr":
            return "%\(content)"
        case "fr":
            return "\(content) %"
        default:
            return "\(content)%"
        }
    }
    
    // MARK: - UI Setup
    
    /// Configures the cell to display the detailed player statistics by adding and configuring views
    private func statsSetup() {
        topWinrateMatches.configurate(
            firstTitle: Texts.StatsDetailsCell.topOne,
            firstContent: String(stats.topOne),
            secondTitle: Texts.StatsDetailsCell.matches,
            secondContent: String(stats.matchesPlayed),
            thirdTitle: Texts.StatsDetailsCell.winrate,
            thirdContent: String(stats.winrate), separator: false)
        
        kdKillsOutlived.configurate(
            firstTitle: Texts.StatsDetailsCell.kills,
            firstContent: String(stats.kills),
            secondTitle: Texts.StatsDetailsCell.outlived,
            secondContent: String(stats.playersOutlived),
            thirdTitle: Texts.StatsDetailsCell.kd,
            thirdContent: String(stats.kd))
        
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
    
    /// Configures the cell to display historical level and progress data by adding and configuring views
    private func historySetup() {
        historyRow.configurate(
            firstTitle: Texts.StatsDetailsCell.level,
            firstContent: String(history.level),
            secondTitle: Texts.StatsDetailsCell.progress,
            secondContent: definePercentage(content: history.progress),
            separator: false)
        stackView.addArrangedSubview(historyRow)
        
        NSLayoutConstraint.activate([
            historyRow.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    /// Adds the stack view to the cell and sets up its constraints
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
    
    /// Prepares the cell for reuse by removing any existing subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeFromSuperview()
    }
}
