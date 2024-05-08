//
//  BattlePassCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit

final class BattlePassCollectionReusableView: UICollectionReusableView {
    
    static let identifier = Texts.BattlePassCell.footerIdentifier
    
    // MARK: - UI Elements and Views
        
    private let seriesView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.series, content: Texts.BattlePassItemsParameters.seriesData)
    private let setView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.set, content: Texts.BattlePassItemsParameters.setData)
    private let payTypeView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.paytype, content: Texts.BattlePassItemsParameters.paytypeDara)
    private let introducedView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.introduced, content: Texts.BattlePassItemsParameters.introducedData)
    private let addedDateView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.addedDate, content: Texts.BattlePassItemsParameters.addedDate)
    private let rewardWallView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.rewardWall, content: Texts.BattlePassItemsParameters.rewardWallData)
    private let levelWallView = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.levelWall, content: Texts.BattlePassItemsParameters.levelWallData)
    private let priceView = CollectionTotalPriceView(frame: .null, price: Texts.BattlePassCell.price)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private let descriptionTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriprion
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriptionData
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Method
    
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
    
    private func setupUI(isSeries: Bool, isDescription: Bool, isSet: Bool, isRewardWall: Bool, isLevelWall: Bool, isIntroduced: Bool, price: String) {
        isDescription ? descriptionSetup() : nil
        
        isSeries ? stackView.addArrangedSubview(seriesView) : nil
        isSet ? stackView.addArrangedSubview(setView) : nil
        stackView.addArrangedSubview(payTypeView)
        isIntroduced ? stackView.addArrangedSubview(introducedView) : nil
        stackView.addArrangedSubview(addedDateView)
        isRewardWall ? stackView.addArrangedSubview(rewardWallView) : nil
        isLevelWall ? stackView.addArrangedSubview(levelWallView) : nil
        
        stackViewSetup(isDescription: isDescription)
        subStackSetup(isSeries: isSeries, isSet: isSet, isRewardWall: isRewardWall, isLevelWall: isLevelWall)
        priceSetup(price: price)
    }
    
    private func stackViewSetup(isDescription: Bool) {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: isDescription ? descriptionContentLabel.bottomAnchor : topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
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

