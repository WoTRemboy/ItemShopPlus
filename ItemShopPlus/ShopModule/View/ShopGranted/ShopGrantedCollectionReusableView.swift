//
//  ShopGrantedCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

final class ShopGrantedCollectionReusableView: UICollectionReusableView {
    
    static let identifier = Texts.ShopGrantedCell.footerIdentifier
    
    // MARK: - UI Elements and Views
    
    private let seriesView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.series, content: Texts.ShopGrantedParameters.seriesData)
    private let firstTimeView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.firstTime, content: Texts.ShopGrantedParameters.firstTimeData)
    private let lastTimeView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.lastTime, content: Texts.ShopGrantedParameters.lastTimeData)
    private let expiryDateView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.expiryDate, content: Texts.ShopGrantedParameters.expiryDateData)
    private let priceView = CollectionTotalPriceView(frame: .null, price: Texts.ShopGrantedCell.price)
    
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
    
    public func configurate(description: String, firstDate: Date, lastDate: Date, expiryDate: Date, series: String?, price: Int) {
        descriptionContentLabel.text = description
        seriesView.configurate(content: series ?? "")
        priceView.configurate(price: String(price), currency: .vbucks)
        
        firstTimeView.configurate(content: DateFormating.dateFormatterDefault(date: firstDate))
        lastTimeView.configurate(content: DateFormating.dateFormatterDefault(date: lastDate))
        expiryDateView.configurate(content: DateFormating.dateFormatterDefault(date: expiryDate))

        setupUI(isSeries: series != nil, isDescription: !description.isEmpty, price: String(price))
    }
    
    // MARK: - UI Setups
    
    private func setupUI(isSeries: Bool, isDescription: Bool, price: String) {
        isDescription ? descriptionSetup() : nil
        
        isSeries ? stackView.addArrangedSubview(seriesView) : nil
        stackView.addArrangedSubview(firstTimeView)
        stackView.addArrangedSubview(lastTimeView)
        stackView.addArrangedSubview(expiryDateView)
        
        stackViewSetup(isDescription: isDescription)
        subStackSetup(isSeries: isSeries)
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
    
    private func subStackSetup(isSeries: Bool) {
        NSLayoutConstraint.activate([
            firstTimeView.heightAnchor.constraint(equalToConstant: 70),
            lastTimeView.heightAnchor.constraint(equalToConstant: 70),
            expiryDateView.heightAnchor.constraint(equalToConstant: 70)
        ])
        isSeries ? seriesView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
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
