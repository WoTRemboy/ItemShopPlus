//
//  CrewFooterReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

class CrewFooterReusableView: UICollectionReusableView {
    
    static let identifier = Texts.CrewPageCell.footerIdentifier
    
    private var symbolPosition: SymbolPosition = .left
    
    private let introductionView = ShopGrantedParametersRowView(frame: .null, title: Texts.CrewPageCell.introductionTitle, content: Texts.CrewPageCell.introductionText)
    private let mainBenefitsView = ShopGrantedParametersRowView(frame: .null, title: Texts.CrewPageCell.mainBenefits, content: Texts.CrewPageCell.no)
    private let addBenefitsView = ShopGrantedParametersRowView(frame: .null, title: Texts.CrewPageCell.additionalBenefints, content: Texts.CrewPageCell.no)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.numberOfLines = 1
        return label
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
    
    public func configurate(price: Double, symbol: String, description: String, introduced: String, battlePass: String, benefits: String) {
        switch symbolPosition {
        case .left:
            priceLabel.text = "\(symbol) \(price)"
        case .right:
            priceLabel.text = "\(price) \(symbol)"
        }
        descriptionContentLabel.text = description
        introductionView.configurate(content: introduced)
        addBenefitsView.configurate(content: benefits)
        mainBenefitsView.configurate(content: "\(Texts.CrewPageCell.vbucks) \(Texts.CrewPageCell.and) \(battlePass)")
        
        descriptionSetup()
        setupUI(price: String(price))
    }
    
    private func descriptionSetup() {
        addSubview(descriptionTitleLable)
        addSubview(descriptionContentLabel)
        addSubview(descriptionSeparatorLine)
        
        descriptionTitleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        
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

    private func setupUI(price: String) {
        addSubview(introductionView)
        addSubview(mainBenefitsView)
        addSubview(addBenefitsView)
        addSubview(totalPriceLabel)
        addSubview(priceLabel)

        introductionView.translatesAutoresizingMaskIntoConstraints = false
        mainBenefitsView.translatesAutoresizingMaskIntoConstraints = false
        addBenefitsView.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            introductionView.topAnchor.constraint(equalTo: descriptionContentLabel.bottomAnchor, constant: 16),
            introductionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            introductionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            introductionView.heightAnchor.constraint(equalToConstant: 70),
            
            mainBenefitsView.topAnchor.constraint(equalTo: introductionView.bottomAnchor),
            mainBenefitsView.leadingAnchor.constraint(equalTo: introductionView.leadingAnchor),
            mainBenefitsView.trailingAnchor.constraint(equalTo: introductionView.trailingAnchor),
            mainBenefitsView.heightAnchor.constraint(equalTo: introductionView.heightAnchor),
            
            addBenefitsView.topAnchor.constraint(equalTo: mainBenefitsView.bottomAnchor),
            addBenefitsView.leadingAnchor.constraint(equalTo: mainBenefitsView.leadingAnchor),
            addBenefitsView.trailingAnchor.constraint(equalTo: mainBenefitsView.trailingAnchor),
            addBenefitsView.heightAnchor.constraint(equalTo: mainBenefitsView.heightAnchor),
            
            totalPriceLabel.topAnchor.constraint(equalTo: addBenefitsView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
}

enum SymbolPosition {
    case left
    case right
}
