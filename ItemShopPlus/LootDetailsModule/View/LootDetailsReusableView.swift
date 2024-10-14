//
//  LootDetailsReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 28.04.2024.
//

import UIKit

/// A custom reusable view for displaying detailed loot stats and optional description
final class LootDetailsReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    /// A static identifier for reusing the view in collection views
    static let identifier = Texts.LootDetailsStatsCell.footerIdentifier
    /// The loot item statistics associated with the view
    private var item: LootItemStats = .emptyStats
    
    /// A computed property that checks if the description label contains text
    private var isDescription: Bool {
        guard let text = descriptionContentLabel.text else { return false }
        return !text.isEmpty
    }
    
    // MARK: - UI Elements and Views
    
    /// A view displaying the damage per bullet stat of the loot item
    private let damageBullet = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.damageBulletTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the firing rate stat of the loot item
    private let firingRate = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.firingRateTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the clip size stat of the loot item
    private let clipSize = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.clipSizeTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the reload time stat of the loot item
    private let reloadTime = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.reloadTimeTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the bullets per cartridge stat of the loot item
    private let bulletsCartridge = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.bulletsCartridgeTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the spread stat of the loot item
    private let spread = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.spreadTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the spread when aiming down sights stat of the loot item
    private let spreadDownsights = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.spreadDownsightsTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A view displaying the critical damage zone multiplier stat of the loot item
    private let damageZone = CollectionParametersRowView(
        frame: .null,
        title: Texts.LootDetailsStatsCell.damageZoneTitle,
        content: Texts.LootDetailsStatsCell.no)
    
    /// A vertical stack view to organize all the stat views
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    /// The label for the description title of the loot item
    private let descriptionTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriprion
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label for displaying the detailed description of the loot item
    private let descriptionContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriptionData
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// A separator line for visual separation of description and stats
    private let descriptionSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    // MARK: - Public Configure Methods
    
    /// Configures the view with the specified loot item stats and description
    /// - Parameters:
    ///   - item: The `LootItemStats` object containing stats about the loot item
    ///   - description: The description text of the loot item
    public func configurate(item: LootItemStats, description: String) {
        self.item = item
        self.descriptionContentLabel.text = description
        
        // Formatting the damage and rate to show with proper precision
        let damageToShow = Int(item.dmgBullet * 10) % 10 == 0 ? String(Int(item.dmgBullet.rounded())) : String(format: "%.1f", item.dmgBullet)
        let rateToShow = Int(item.firingRate * 10) % 10 == 0 ? String(Int(item.firingRate.rounded())) : String(format: "%.1f", item.firingRate)
        
        // Configuring each stat row with the corresponding stat values
        damageBullet.configurate(content: "\(Texts.LootDetailsStatsCell.damageBullets) \(damageToShow)")
        firingRate.configurate(content: "\(Texts.LootDetailsStatsCell.roundsSecond) \(rateToShow)")
        clipSize.configurate(content: "\(Texts.LootDetailsStatsCell.rounds) \(item.clipSize)")
        reloadTime.configurate(content: "\(Texts.LootDetailsStatsCell.seconds) \(item.reloadTime)")
        bulletsCartridge.configurate(content: "\(Texts.LootDetailsStatsCell.rounds) \(item.inCartridge)")
        spread.configurate(content: "\(Texts.LootDetailsStatsCell.multiplier) \(item.spread)")
        spreadDownsights.configurate(content: "\(Texts.LootDetailsStatsCell.multiplier) \(item.downsight)")
        damageZone.configurate(content: "\(Texts.LootDetailsStatsCell.multiplier) \(item.zoneCritical)")
        
        setupUI()
    }
    
    // MARK: - UI Setups
    
    /// Sets up the stack view that holds all the stat views
    private func stackViewSetup() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add stat views conditionally based on whether they have values
        item.dmgBullet != 0 ? stackView.addArrangedSubview(damageBullet) : nil
        item.firingRate != 0 ? stackView.addArrangedSubview(firingRate) : nil
        item.clipSize != 0 ? stackView.addArrangedSubview(clipSize) : nil
        item.reloadTime != 0 ? stackView.addArrangedSubview(reloadTime) : nil
        item.inCartridge != 0 ? stackView.addArrangedSubview(bulletsCartridge) : nil
        item.spread != 0 ? stackView.addArrangedSubview(spread) : nil
        item.downsight != 0 ? stackView.addArrangedSubview(spreadDownsights) : nil
        item.zoneCritical != 0 ? stackView.addArrangedSubview(damageZone) : nil

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: isDescription ? descriptionContentLabel.bottomAnchor : topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    /// Sets up the description section
    private func descriptionSetup() {
        addSubview(descriptionSeparatorLine)
        addSubview(descriptionTitleLable)
        addSubview(descriptionContentLabel)
        
        descriptionSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionSeparatorLine.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            descriptionSeparatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionSeparatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionTitleLable.bottomAnchor.constraint(equalTo: descriptionSeparatorLine.topAnchor, constant: 70/2 - 2),
            descriptionTitleLable.leadingAnchor.constraint(equalTo: descriptionSeparatorLine.leadingAnchor),
            descriptionTitleLable.trailingAnchor.constraint(equalTo: descriptionSeparatorLine.trailingAnchor),
            
            descriptionContentLabel.topAnchor.constraint(equalTo: descriptionTitleLable.bottomAnchor, constant: 4),
            descriptionContentLabel.leadingAnchor.constraint(equalTo: descriptionTitleLable.leadingAnchor),
            descriptionContentLabel.trailingAnchor.constraint(equalTo: descriptionTitleLable.trailingAnchor)
        ])
    }
    
    /// Sets up the entire UI for the loot stats view, including the stack view and optional description
    private func setupUI() {
        isDescription ? descriptionSetup() : nil
        stackViewSetup()
        
        NSLayoutConstraint.activate([
            damageBullet.heightAnchor.constraint(equalToConstant: 70),
            firingRate.heightAnchor.constraint(equalToConstant: 70),
            clipSize.heightAnchor.constraint(equalToConstant: 70),
            reloadTime.heightAnchor.constraint(equalToConstant: 70),
            bulletsCartridge.heightAnchor.constraint(equalToConstant: 70),
            spread.heightAnchor.constraint(equalToConstant: 70),
            spreadDownsights.heightAnchor.constraint(equalToConstant: 70),
            damageZone.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}
