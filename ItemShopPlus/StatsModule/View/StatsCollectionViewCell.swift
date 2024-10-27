//
//  StatsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit

/// A custom collection view cell that displays statistics related to a specific segment (e.g., global stats, input stats, history)
final class StatsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The identifier used to dequeue reusable cells of this type
    static let identifier = Texts.StatsCell.identifier
    
    // MARK: - UI Elements and Views
    
    /// The title label that shows the name of the stats section (e.g., "Global", "Input")
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String()
        label.textColor = .labelPrimary
        label.font = .title()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label for displaying the title of the first stat (e.g., "Wins", "Kills")
    private let firstStatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.firstStatPlaceholder
        label.textColor = .labelPrimary
        label.font = .body()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    /// The label for displaying the value of the first stat
    private let firstStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label for displaying the title of the second stat
    private let secondStatTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.secondStatPlaceholder
        label.textColor = .labelPrimary
        label.font = .body()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    /// The label for displaying the value of the second stat
    private let secondStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// An image view to display an icon representing the stats section (e.g., global stats, input stats)
    private let sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// A separator line placed between the first and second stat value
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the provided data
    /// - Parameters:
    ///   - type: The segment type of the stats (e.g., title, global, input, history)
    ///   - firstStat: The value of the first statistic
    ///   - secondStat: The value of the second statistic
    public func configurate(type: StatsSegment, firstStat: Double, secondStat: Double) {
        backgroundColor = .BackColors.backElevated
        layer.cornerRadius = 25
        layer.shadowColor = UIColor.Shadows.primary
        layer.borderColor = UIColor.LabelColors.labelDisable?.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        layer.borderWidth = 0
        
        switch type {
        case .title:
            titleLabel.text = Texts.StatsPage.progressTitle
            firstStatTitleLabel.text = Texts.StatsPage.progressFirst
            firstStatValueLabel.text = "\(Int(firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.progressSecond
            secondStatValueLabel.text = "\(Int(secondStat))"
            sectionImageView.image = .Stats.progress
            backgroundColor = .BackColors.backDefault
            layer.shadowRadius = 0
            layer.shadowOpacity = 0
            layer.borderWidth = 2

        case .global:
            titleLabel.text = Texts.StatsPage.globalTitle
            firstStatTitleLabel.text = Texts.StatsPage.globalFirst
            firstStatValueLabel.text = "\(Int(firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.globalSecond
            secondStatValueLabel.text = "\(String(format: "%.2f", secondStat))"
            sectionImageView.image = .Stats.global
        case .input:
            titleLabel.text = Texts.StatsPage.inputTitle
            firstStatTitleLabel.text = Texts.StatsPage.inputFirst
            firstStatValueLabel.text = "\(String(format: "%.2f", firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.inputSecond
            secondStatValueLabel.text = "\(String(format: "%.2f", secondStat))"
            sectionImageView.image = .Stats.input
        case .history:
            titleLabel.text = Texts.StatsPage.historyTitle
            firstStatTitleLabel.text = Texts.StatsPage.historyFirst
            firstStatValueLabel.text = "\(Int(firstStat))"
            secondStatTitleLabel.text = Texts.StatsPage.historySecond
            secondStatValueLabel.text = "\(Int(secondStat))"
            sectionImageView.image = .Stats.history
        }
        setupUI()
    }
    
    /// Returns the text of the title label
    /// - Returns: The current text of the `titleLabel`, or `nil` if not set
    internal func getTitleText() -> String? {
        return titleLabel.text
    }
    
    /// Updates the border color to match the new trait collection
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.LabelColors.labelDisable?.cgColor
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements by adding them to the view and configuring constraints
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
            separatorLine.bottomAnchor.constraint(equalTo: firstStatTitleLabel.bottomAnchor, constant: 7),
            separatorLine.widthAnchor.constraint(equalToConstant: 2),
            separatorLine.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            
            firstStatValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            firstStatValueLabel.leadingAnchor.constraint(equalTo: sectionImageView.trailingAnchor, constant: 16),
            firstStatValueLabel.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: -16),
            
            firstStatTitleLabel.topAnchor.constraint(equalTo: firstStatValueLabel.bottomAnchor, constant: 16),
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
    
    /// Prepares the cell for reuse by resetting properties such as shadows and borders
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.borderWidth = 0
    }
}
