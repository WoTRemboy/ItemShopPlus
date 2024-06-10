//
//  StatsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit

final class StatsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.StatsCell.identifier
    
    // MARK: - UI Elements and Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String()
        label.textColor = .labelPrimary
        label.font = .title()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
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
    
    private let firstStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
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
    
    private let secondStatValueLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.StatsCell.statValuePlaceholder
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Public Configure Method
    
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
    
    internal func getTitleText() -> String? {
        return titleLabel.text
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.LabelColors.labelDisable?.cgColor
        }
    }
    
    // MARK: - UI Setup
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.borderWidth = 0
    }
}
