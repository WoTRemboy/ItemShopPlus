//
//  BattlePassCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit

/// Custom reusable view used as a footer view in the Battle Pass collection view to display detailed information about the selected Battle Pass item
final class BattlePassCollectionReusableView: UICollectionReusableView {
    
    /// Identifier used for dequeuing the footer view in the collection view
    static let identifier = Texts.BattlePassCell.footerIdentifier
    
    // MARK: - UI Elements and Views
    
    /// View to display information about the item's series
    private let seriesView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.series,
        content: Texts.BattlePassItemsParameters.seriesData)
    /// View to display information about the item's set
    private let setView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.set,
        content: Texts.BattlePassItemsParameters.setData)
    /// View to display information about the item's payment type
    private let payTypeView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.paytype,
        content: Texts.BattlePassItemsParameters.paytypeDara)
    /// View to display information about the item's introduction
    private let introducedView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.introduced,
        content: Texts.BattlePassItemsParameters.introducedData)
    /// View to display the date the item was added to the Battle Pass
    private let addedDateView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.addedDate,
        content: Texts.BattlePassItemsParameters.addedDate)
    /// View to display the rewards wall required to unlock the item
    private let rewardWallView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.rewardWall,
        content: Texts.BattlePassItemsParameters.rewardWallData)
    /// View to display the level wall required to unlock the item
    private let levelWallView = CollectionParametersRowView(
        frame: .null,
        title: Texts.BattlePassItemsParameters.levelWall,
        content: Texts.BattlePassItemsParameters.levelWallData)
    /// View to display the total price of the item in the collection
    private let priceView = CollectionTotalPriceView(
        frame: .null,
        price: Texts.BattlePassCell.price)
    
    /// Stack view used to organize and align the parameter views vertically
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    /// Label displaying the title of the description section
    private let descriptionTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriprion
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// Label displaying the content of the description section
    private let descriptionContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriptionData
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// Separator line used to visually separate the description section
    private let descriptionSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    /// Label displaying the total price information
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the footer view with the given Battle Pass item details
    /// - Parameters:
    ///   - description: A description of the Battle Pass item
    ///   - series: The series the item belongs to
    ///   - set: The set the item is part of
    ///   - payType: The payment type required to unlock the item (free or paid)
    ///   - introduced: The season and chapter when the item was introduced
    ///   - addedDate: he date when the item was added to the Battle Pass
    ///   - rewardWall: The number of rewards required to unlock the item
    ///   - levelWall: The level required to unlock the item
    ///   - price: The price of the item
    public func configurate(description: String, series: String?, set: String?, payType: PayType, introduced: String, addedDate: Date, rewardWall: Int, levelWall: Int, price: Int) {
        descriptionContentLabel.text = description
        seriesView.configurate(content: series ?? "")
        setView.configurate(content: set ?? "")
        payTypeView.configurate(content: SelectingMethods.selectPayType(payType: payType))
        introducedView.configurate(content: introduced)
        addedDateView.configurate(content: DateFormating.dateFormatterDefault(date: addedDate))
        rewardWallView.configurate(content: String(rewardWall))
        levelWallView.configurate(content: String(levelWall))
        priceView.configurate(price: String(price), currency: .star)

        setupUI(isSeries: series != nil, isDescription: !description.isEmpty, isSet: set != nil, isRewardWall: rewardWall != 0, isLevelWall: levelWall != 0, isIntroduced: !introduced.isEmpty, price: String(price))
    }
    
    // MARK: - UI Setups
    
    /// Sets up the layout and constraints for the stack view and other UI elements based on the provided flags
    /// - Parameters:
    ///   - isSeries: Boolean indicating whether the series view should be displayed
    ///   - isDescription: Boolean indicating whether the description section should be displayed
    ///   - isSet: Boolean indicating whether the set view should be displayed
    ///   - isRewardWall: Boolean indicating whether the reward wall view should be displayed
    ///   - isLevelWall: Boolean indicating whether the level wall view should be displayed
    ///   - isIntroduced: Boolean indicating whether the introduced view should be displayed
    ///   - price: The price of the item
    private func setupUI(isSeries: Bool, isDescription: Bool, isSet: Bool, isRewardWall: Bool, isLevelWall: Bool, isIntroduced: Bool, price: String) {
        // If a description is available, set up the description section
        isDescription ? descriptionSetup() : nil
        
        // Add each view to the stack view if the corresponding flag is true
        isSeries ? stackView.addArrangedSubview(seriesView) : nil
        isSet ? stackView.addArrangedSubview(setView) : nil
        stackView.addArrangedSubview(payTypeView)
        isIntroduced ? stackView.addArrangedSubview(introducedView) : nil
        stackView.addArrangedSubview(addedDateView)
        isRewardWall ? stackView.addArrangedSubview(rewardWallView) : nil
        isLevelWall ? stackView.addArrangedSubview(levelWallView) : nil
        
        // Set up the stack view and its constraints
        stackViewSetup(isDescription: isDescription)
        // Set up subviews constraints
        subStackSetup(isSeries: isSeries, isSet: isSet, isRewardWall: isRewardWall, isLevelWall: isLevelWall)
        // Set up the price view and its constraints
        priceSetup(price: price)
    }
    
    /// Sets up the constraints for the main stack view
    /// - Parameter isDescription: Boolean indicating whether the description section is present
    private func stackViewSetup(isDescription: Bool) {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: isDescription ? descriptionContentLabel.bottomAnchor : topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    /// Sets up the constraints for the individual subviews within the stack view
    /// - Parameters:
    ///   - isSeries: Boolean indicating whether the series view is present
    ///   - isSet: Boolean indicating whether the set view is present
    ///   - isRewardWall: Boolean indicating whether the reward wall view is present
    ///   - isLevelWall: Boolean indicating whether the level wall view is present
    private func subStackSetup(isSeries: Bool, isSet: Bool, isRewardWall: Bool, isLevelWall: Bool) {
        NSLayoutConstraint.activate([
            payTypeView.heightAnchor.constraint(equalToConstant: 70),
            introducedView.heightAnchor.constraint(equalToConstant: 70),
            addedDateView.heightAnchor.constraint(equalToConstant: 70)
        ])
        isSeries ? seriesView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
        isSet ? setView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
        isRewardWall ? rewardWallView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
        isLevelWall ? levelWallView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
    }
    
    /// Sets up the description section if the description text is present
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
    
    /// Sets up the price view and its constraints
    /// - Parameter price: The price of the item
    private func priceSetup(price: String) {
        addSubview(totalPriceLabel)
        addSubview(priceView)
        
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceView.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceView.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 25),
            priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * price.count))) // vBucks icon + price widths
        ])
    }
}

