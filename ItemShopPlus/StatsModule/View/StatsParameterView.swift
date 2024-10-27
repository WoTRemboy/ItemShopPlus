//
//  StatsParameterView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

/// A custom view used to display a set of three statistics parameters
final class StatsParameterView: UIView {
    
    // MARK: - UI Elements
    
    /// The label displaying the title of the first stat (e.g., "Top 1")
    private let firstTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the content for the first stat
    private let firstContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the title of the second stat (e.g., "Matches")
    private let secondTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the content for the second stat
    private let secondContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the content for the third stat (e.g., the number of matches played)
    private let thirdTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the content for the second stat
    private let thirdContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// A separator line to visually divide content
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Public Configuration Method
    
    /// Configures the view to display the provided stat titles and contents
    /// - Parameters:
    ///   - firstTitle: The title for the first stat (e.g., "Top 1")
    ///   - firstContent: The content for the first stat (e.g., "5")
    ///   - secondTitle: The title for the second stat (e.g., "Matches")
    ///   - secondContent: The content for the second stat (e.g., "20")
    ///   - thirdTitle: The title for the optional third stat (e.g., "Winrate")
    ///   - thirdContent: The content for the optional third stat (e.g., "50%")
    ///   - separator: Boolean indicating whether to show a separator line
    public func configurate(firstTitle: String, firstContent: String, secondTitle: String, secondContent: String, thirdTitle: String = String(), thirdContent: String = String(), separator: Bool = true) {
        firstTitleLable.text = firstTitle
        firstContentLabel.text = firstContent
        secondTitleLable.text = secondTitle
        secondContentLabel.text = secondContent
        thirdTitleLable.text = thirdTitle
        thirdContentLabel.text = thirdContent
        
        separatorLine.isHidden = !separator
        thirdTitle.isEmpty ? setupDoubleUI() : setupTripleUI()
    }
    
    // MARK: - Private UI Setup Methods
    
    /// Sets up the UI for two statistics. This method is called when the third stat title is empty
    private func setupDoubleUI() {
        addSubview(separatorLine)
        addSubview(firstTitleLable)
        addSubview(firstContentLabel)
        addSubview(secondTitleLable)
        addSubview(secondContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLable.translatesAutoresizingMaskIntoConstraints = false
        firstContentLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLable.translatesAutoresizingMaskIntoConstraints = false
        secondContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            firstTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            firstTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -(UIScreen.main.bounds.width / 6)),
            firstTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            firstContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            firstContentLabel.leadingAnchor.constraint(equalTo: firstTitleLable.leadingAnchor),
            firstContentLabel.trailingAnchor.constraint(equalTo: firstTitleLable.trailingAnchor),
            
            secondTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            secondTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width / 6),
            secondTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            secondContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            secondContentLabel.centerXAnchor.constraint(equalTo: secondTitleLable.centerXAnchor),
            secondContentLabel.widthAnchor.constraint(equalTo: secondTitleLable.widthAnchor)
        ])
    }
    
    /// Sets up the UI for three statistics. This method is called when the third stat title is provided
    private func setupTripleUI() {
        addSubview(separatorLine)
        addSubview(firstTitleLable)
        addSubview(firstContentLabel)
        addSubview(secondTitleLable)
        addSubview(secondContentLabel)
        addSubview(thirdTitleLable)
        addSubview(thirdContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLable.translatesAutoresizingMaskIntoConstraints = false
        firstContentLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLable.translatesAutoresizingMaskIntoConstraints = false
        secondContentLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdTitleLable.translatesAutoresizingMaskIntoConstraints = false
        thirdContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            firstTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            firstTitleLable.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: 16),
            firstTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            firstContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            firstContentLabel.leadingAnchor.constraint(equalTo: firstTitleLable.leadingAnchor),
            firstContentLabel.trailingAnchor.constraint(equalTo: firstTitleLable.trailingAnchor),
            
            secondTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            secondTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            secondContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            secondContentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondContentLabel.widthAnchor.constraint(equalTo: secondTitleLable.widthAnchor),
            
            thirdTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            thirdTitleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: -16),
            thirdTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            thirdContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            thirdContentLabel.leadingAnchor.constraint(equalTo: thirdTitleLable.leadingAnchor),
            thirdContentLabel.trailingAnchor.constraint(equalTo: thirdTitleLable.trailingAnchor)
        ])
    }
}

