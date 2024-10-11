//
//  BattlePassSeasonParameterRow.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 03.03.2024.
//

import UIKit

/// A custom view to display the start and end date information of a Battle Pass season
final class BattlePassSeasonParameterRow: UIView {
    
    // MARK: - UI Elements and Views
    
    /// Label displaying the title for the beginning date of the season (e.g., "Begin Date")
    private let beginTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// Label displaying the content for the beginning date of the season (e.g., "01.01.2024")
    private let beginContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.numberOfLines = 1
        return label
    }()
    
    /// Label displaying the title for the ending date of the season (e.g., "End Date")
    private let endTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    /// Label displaying the content for the ending date of the season (e.g., "01.03.2024")
    private let endContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    /// A horizontal separator line at the top of the view for visual separation
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view with the given titles and contents for the begin and end labels.
    /// - Parameters:
    ///   - frame: The frame rectangle for the view, measured in points
    ///   - beginTitle: The text for the begin title label
    ///   - beginContent: The text for the begin content label
    ///   - endTitle: The text for the end title label
    ///   - endContent: The text for the end content label
    init(frame: CGRect, beginTitle: String, beginContent: String, endTitle: String, endContent: String) {
        beginTitleLable.text = beginTitle
        beginContentLabel.text = beginContent
        endTitleLable.text = endTitle
        endContentLabel.text = endContent
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    
    /// Configures the content labels for the begin and end dates
    /// - Parameters:
    ///   - content: The text for the begin content label
    ///   - end: The text for the end content label
    public func configurate(content: String, _ end: String) {
        beginContentLabel.text = content
        endContentLabel.text = end
    }
    
    // MARK: - UI Setup
    
    /// Sets up the layout and constraints for the labels and separator line within the view
    private func setupUI() {
        addSubview(separatorLine)
        addSubview(beginTitleLable)
        addSubview(beginContentLabel)
        addSubview(endTitleLable)
        addSubview(endContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        beginTitleLable.translatesAutoresizingMaskIntoConstraints = false
        beginContentLabel.translatesAutoresizingMaskIntoConstraints = false
        endTitleLable.translatesAutoresizingMaskIntoConstraints = false
        endContentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Separator Line Constraints
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Begin Title Label Constraints
            beginTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            beginTitleLable.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            beginTitleLable.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            // Begin Content Label Constraints
            beginContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            beginContentLabel.leadingAnchor.constraint(equalTo: beginTitleLable.leadingAnchor),
            beginContentLabel.trailingAnchor.constraint(equalTo: beginTitleLable.trailingAnchor),
            
            // End Title Label Constraints
            endTitleLable.bottomAnchor.constraint(equalTo: beginTitleLable.bottomAnchor),
            endTitleLable.leadingAnchor.constraint(equalTo: beginTitleLable.trailingAnchor, constant: 5),
            endTitleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            
            // End Content Label Constraints
            endContentLabel.topAnchor.constraint(equalTo: beginContentLabel.topAnchor),
            endContentLabel.leadingAnchor.constraint(equalTo: endTitleLable.leadingAnchor),
            endContentLabel.trailingAnchor.constraint(equalTo: endTitleLable.trailingAnchor)
        ])
    }
}
