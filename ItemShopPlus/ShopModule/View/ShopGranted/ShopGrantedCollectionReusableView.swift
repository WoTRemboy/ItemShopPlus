//
//  ShopGrantedCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

class ShopGrantedCollectionReusableView: UICollectionReusableView {
    
    static let identifier = Texts.ShopGrantedCell.footerIdentifier
    
    private let seriesView = ShopGrantedParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.series, content: Texts.ShopGrantedParameters.seriesData)
    private let firstTimeView = ShopGrantedParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.firstTime, content: Texts.ShopGrantedParameters.firstTimeData)
    private let lastTimeView = ShopGrantedParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.lastTime, content: Texts.ShopGrantedParameters.lastTimeData)
    private let priceView = ShopGrantedTotalPriceView(frame: .null, price: Texts.ShopGrantedCell.price)
    
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
    
    public func configurate(description: String, firstDate: Date, lastDate: Date, series: String?, price: Int) {
        descriptionContentLabel.text = description
        seriesView.configurate(content: series ?? "")
        
        firstTimeView.configurate(content: DateFormating.dateFormatterShopGranted.string(from: firstDate))
        lastTimeView.configurate(content: DateFormating.dateFormatterShopGranted.string(from: lastDate))
        
        priceView.priceLabel.text = String(price)
        
        setupUI(isSeries: series != nil, isDescription: !description.isEmpty, price: String(price))
    }

    private func setupUI(isSeries: Bool, isDescription: Bool, price: String) {
        addSubview(firstTimeView)
        addSubview(lastTimeView)
        addSubview(totalPriceLabel)
        addSubview(priceView)

        firstTimeView.translatesAutoresizingMaskIntoConstraints = false
        lastTimeView.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        if isDescription {
            addSubview(descriptionTitleLable)
            addSubview(descriptionContentLabel)
            addSubview(descriptionSeparatorLine)
            
            descriptionTitleLable.translatesAutoresizingMaskIntoConstraints = false
            descriptionContentLabel.translatesAutoresizingMaskIntoConstraints = false
            descriptionSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if isSeries {
            addSubview(seriesView)
            seriesView.translatesAutoresizingMaskIntoConstraints = false
        }
       
        NSLayoutConstraint.activate([
            firstTimeView.topAnchor.constraint(equalTo: isSeries ? seriesView.bottomAnchor : (isDescription ? descriptionContentLabel.bottomAnchor : topAnchor), constant: !isSeries && !isDescription ? 16 : (isDescription && !isSeries ? (70/2 - 2 - 15) : 0)),
            firstTimeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            firstTimeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            firstTimeView.heightAnchor.constraint(equalToConstant: 70),
            
            lastTimeView.topAnchor.constraint(equalTo: firstTimeView.bottomAnchor),
            lastTimeView.leadingAnchor.constraint(equalTo: firstTimeView.leadingAnchor),
            lastTimeView.trailingAnchor.constraint(equalTo: firstTimeView.trailingAnchor),
            lastTimeView.heightAnchor.constraint(equalToConstant: 70),
            
            totalPriceLabel.topAnchor.constraint(equalTo: lastTimeView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceView.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceView.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 25),
            priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * price.count))) // vBucks icon + price widths
        ])
                        
        if isDescription {
            NSLayoutConstraint.activate([
                descriptionSeparatorLine.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                descriptionSeparatorLine.leadingAnchor.constraint(equalTo: firstTimeView.leadingAnchor),
                descriptionSeparatorLine.trailingAnchor.constraint(equalTo: firstTimeView.trailingAnchor),
                descriptionSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
                
                descriptionTitleLable.bottomAnchor.constraint(equalTo: descriptionSeparatorLine.topAnchor, constant: 70/2 - 2),
                descriptionTitleLable.leadingAnchor.constraint(equalTo: descriptionSeparatorLine.leadingAnchor),
                descriptionTitleLable.trailingAnchor.constraint(equalTo: descriptionSeparatorLine.trailingAnchor),
                
                descriptionContentLabel.topAnchor.constraint(equalTo: descriptionTitleLable.bottomAnchor, constant: 4),
                descriptionContentLabel.leadingAnchor.constraint(equalTo: descriptionTitleLable.leadingAnchor),
                descriptionContentLabel.trailingAnchor.constraint(equalTo: descriptionTitleLable.trailingAnchor)
            ])
        }
        
        if isSeries {
            NSLayoutConstraint.activate([
                seriesView.topAnchor.constraint(equalTo: isDescription ? descriptionContentLabel.bottomAnchor : topAnchor, constant: isDescription ? (70/2 - 2 - 15) : 16),
                seriesView.leadingAnchor.constraint(equalTo: firstTimeView.leadingAnchor),
                seriesView.trailingAnchor.constraint(equalTo: firstTimeView.trailingAnchor),
                seriesView.heightAnchor.constraint(equalToConstant: 70)
            ])
        }
    }
}
