//
//  LootDetailsMainCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.04.2024.
//

import UIKit
import Kingfisher

/// A custom collection view cell for displaying loot item details in the Loot Details section.
final class LootDetailsMainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// Cell identifier for reuse
    static let identifier = Texts.LootDetailsMainCell.identifier
    /// Task responsible for downloading the image asynchronously
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// Label to display the title of the loot item
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String()
        label.textColor = .labelPrimary
        label.font = .title()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// Label to display the title of the first stat
    private let firstStatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.firstStatPlaceholder
        label.textColor = .labelPrimary
        label.font = .body()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    /// Label to display the value of the first stat
    private let firstStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// Label to display the title of the second stat
    private let secondStatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.secondStatPlaceholder
        label.textColor = .labelPrimary
        label.font = .body()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    /// Label to display the value of the second stat
    private let secondStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// Image view to display the loot item's image
    private let sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .IconColors.LootItemColor
        return imageView
    }()
    
    /// A separator line to visually divide the UI elements
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the provided loot item data
    /// - Parameters:
    ///   - type: The type of the loot item (weapon, health, or trap)
    ///   - name: The name of the loot item
    ///   - image: The URL of the loot item's image
    ///   - firstStat: The first stat value to display
    ///   - secondStat: The second stat value to display
    public func configurate(type: LootItemGameType, name: String, image: String, firstStat: Double, secondStat: Double) {
        backgroundColor = .BackColors.backElevated
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.Shadows.primary
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        // Load image asynchronously using Kingfisher
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: sectionImageView, size: CGSize(width: 512, height: 512))
        
        // Configure the cell based on the type of loot item
        switch type {
        case .weapon:
            titleLabel.text = name
            firstStatTitleLabel.text = Texts.LootDetailsMainCell.rarities
            firstStatValueLabel.text = "\(Int(firstStat))"
            secondStatTitleLabel.text = Texts.LootDetailsMainCell.stats
            secondStatValueLabel.text = "\(Int(secondStat))"
        case .health:
            titleLabel.text = Texts.StatsPage.inputTitle
            firstStatTitleLabel.text = Texts.StatsPage.inputFirst
            firstStatValueLabel.text = "\(String(format: "%.2f", firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.inputSecond
            secondStatValueLabel.text = "\(String(format: "%.2f", secondStat))"
        case .trap:
            titleLabel.text = Texts.StatsPage.historyTitle
            firstStatTitleLabel.text = Texts.StatsPage.historyFirst
            firstStatValueLabel.text = "\(Int(firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.historySecond
            secondStatValueLabel.text = "\(Int(secondStat))"
        }
        setupUI()
    }
    
    /// Returns the text of the title label
    /// - Returns: Title text as String
    internal func getTitleText() -> String? {
        return titleLabel.text
    }
    
    /// Responds to changes in trait collection, such as light/dark mode transitions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.LabelColors.labelDisable?.cgColor
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and layout constraints for the cell
    private func setupUI() {
        addSubview(sectionImageView)
        addSubview(titleLabel)
        addSubview(separatorLine)
        addSubview(firstStatValueLabel)
        addSubview(firstStatTitleLabel)
        addSubview(secondStatValueLabel)
        addSubview(secondStatTitleLabel)
        
        sectionImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        firstStatValueLabel.translatesAutoresizingMaskIntoConstraints = false
        firstStatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondStatValueLabel.translatesAutoresizingMaskIntoConstraints = false
        secondStatTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            sectionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            sectionImageView.widthAnchor.constraint(equalTo: sectionImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: sectionImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            separatorLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22),
            separatorLine.widthAnchor.constraint(equalToConstant: 2),
            separatorLine.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            firstStatValueLabel.bottomAnchor.constraint(equalTo: separatorLine.centerYAnchor, constant: -8),
            firstStatValueLabel.leadingAnchor.constraint(equalTo: sectionImageView.trailingAnchor, constant: 16),
            firstStatValueLabel.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: -16),
            
            firstStatTitleLabel.topAnchor.constraint(equalTo: separatorLine.centerYAnchor, constant: 8),
            firstStatTitleLabel.leadingAnchor.constraint(equalTo: firstStatValueLabel.leadingAnchor),
            firstStatTitleLabel.trailingAnchor.constraint(equalTo: firstStatValueLabel.trailingAnchor),
            
            secondStatValueLabel.topAnchor.constraint(equalTo: firstStatValueLabel.topAnchor),
            secondStatValueLabel.leadingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: 16),
            secondStatValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            secondStatTitleLabel.topAnchor.constraint(equalTo: secondStatValueLabel.bottomAnchor, constant: 16),
            secondStatTitleLabel.leadingAnchor.constraint(equalTo: secondStatValueLabel.leadingAnchor),
            secondStatTitleLabel.trailingAnchor.constraint(equalTo: secondStatValueLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    /// Prepares the cell for reuse by resetting necessary properties and canceling image loading tasks
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        sectionImageView.image = .Placeholder.noImage
    }
}
