//
//  CrewFooterReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

final class CrewFooterReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = Texts.CrewPageCell.footerIdentifier
    private var symbolPosition: CurrencySymbolPosition = .left
    
    // MARK: - UI Elements and Views
    
    private let introductionView = CollectionParametersRowView(frame: .null, title: Texts.CrewPageCell.introductionTitle, content: Texts.CrewPageCell.introductionText)
    private let mainBenefitsView = CollectionParametersRowView(frame: .null, title: Texts.CrewPageCell.mainBenefits, content: Texts.CrewPageCell.no)
    private let addBenefitsView = CollectionParametersRowView(frame: .null, title: Texts.CrewPageCell.additionalBenefints, content: Texts.CrewPageCell.no)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.textAlignment = .center
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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Public Configure Methods
    
    public func configurate(price: CrewPrice, description: String, introduced: String, battlePass: String, benefits: String) {
        changePrice(price: price, firstTime: true)
        descriptionContentLabel.text = description
        
        introductionView.configurate(content: introduced)
        addBenefitsView.configurate(content: benefits)
        mainBenefitsView.configurate(content: "\(Texts.CrewPageCell.vbucks) \(Texts.CrewPageCell.and) \(battlePass)")
        
        setupUI()
    }
    
    public func changePrice(price: CrewPrice, firstTime: Bool) {
        symbolPosition = SelectingMethods.selectCurrencyPosition(type: price.type)
        let priceToShow = Int(price.price * 10) % 10 == 0 ? String(Int(price.price.rounded())) : String(price.price)
        
        switch symbolPosition {
        case .left:
            UIView.transition(with: priceLabel, duration: firstTime ? 0 : 0.3, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(price.symbol) \(priceToShow)"
            }, completion: nil)
        case .right:
            UIView.transition(with: priceLabel, duration: 0.5, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(priceToShow) \(price.symbol)"
            }, completion: nil)
        }
    }
    
    // MARK: - UI Setups
    
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
    
    private func stackViewSetup() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(introductionView)
        stackView.addArrangedSubview(mainBenefitsView)
        stackView.addArrangedSubview(addBenefitsView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionContentLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func totalPriceSetup() {
        addSubview(totalPriceLabel)
        addSubview(priceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupUI() {
        descriptionSetup()
        stackViewSetup()
        totalPriceSetup()
        
        NSLayoutConstraint.activate([
            introductionView.heightAnchor.constraint(equalToConstant: 70),
            mainBenefitsView.heightAnchor.constraint(equalTo: introductionView.heightAnchor),
            addBenefitsView.heightAnchor.constraint(equalTo: mainBenefitsView.heightAnchor),
        ])
    }
}


