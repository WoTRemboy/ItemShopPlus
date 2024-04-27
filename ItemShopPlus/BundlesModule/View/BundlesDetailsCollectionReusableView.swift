//
//  BundlesDetailsCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit

final class BundlesDetailsCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = Texts.BundleDetailsCell.footerIdentifier
    private var symbolPosition: CurrencySymbolPosition = .left
    
    // MARK: - UI Elements and Views
    
    private let expiryDate = CollectionParametersRowView(frame: .null, title: Texts.BundleDetailsCell.expiryDate, content: Texts.BundleDetailsCell.expiryDateText)
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let aboutTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.BundleDetailsCell.about
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let aboutContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.BundleDetailsCell.aboutText
        label.textColor = .labelPrimary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    private let aboutSeparatorLine: UIView = {
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
    
    // MARK: - Public Configure Methods
    
    public func configurate(price: BundlePrice, description: String, about: String, expireDate: Date?) {
        changePrice(price: price, firstTime: true)
        aboutContentLabel.text = about
        if let expireDate {
            expiryDate.configurate(content: DateFormating.dateFormatterDMY.string(from: expireDate))
        }
        
        setupUI(isDate: expireDate != nil)
    }
    
    public func changePrice(price: BundlePrice, firstTime: Bool) {
        symbolPosition = SelectingMethods.selectCurrencyPosition(type: price.type)
        let priceToShow = Int(price.price * 10) % 10 == 0 ? String(Int(price.price.rounded())) : String(price.price)
        
        switch symbolPosition {
        case .left:
            UIView.transition(with: priceLabel, duration: firstTime ? 0 : 0.3, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(price.symbol) \(priceToShow)"
            }, completion: nil)
        case .right:
            UIView.transition(with: priceLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(priceToShow) \(price.symbol)"
            }, completion: nil)
        }
    }
    
    // MARK: - UI Setups
    
    private func expireDateSetup() {
        addSubview(expiryDate)
        expiryDate.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expiryDate.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            expiryDate.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            expiryDate.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            expiryDate.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func aboutSetup(isDate: Bool) {
        addSubview(aboutTitleLable)
        addSubview(aboutContentLabel)
        addSubview(aboutSeparatorLine)
        
        aboutTitleLable.translatesAutoresizingMaskIntoConstraints = false
        aboutContentLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aboutSeparatorLine.topAnchor.constraint(equalTo: isDate ? expiryDate.bottomAnchor : topAnchor, constant: isDate ? 0 : 16),
            aboutSeparatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            aboutSeparatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            aboutSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            aboutTitleLable.bottomAnchor.constraint(equalTo: aboutSeparatorLine.topAnchor, constant: 70/2 - 2),
            aboutTitleLable.leadingAnchor.constraint(equalTo: aboutSeparatorLine.leadingAnchor),
            aboutTitleLable.trailingAnchor.constraint(equalTo: aboutSeparatorLine.trailingAnchor),
            
            aboutContentLabel.topAnchor.constraint(equalTo: aboutTitleLable.bottomAnchor, constant: 4),
            aboutContentLabel.leadingAnchor.constraint(equalTo: aboutTitleLable.leadingAnchor),
            aboutContentLabel.trailingAnchor.constraint(equalTo: aboutTitleLable.trailingAnchor)
        ])
    }
    
    private func totalPriceSetup() {
        addSubview(totalPriceLabel)
        addSubview(priceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: aboutContentLabel.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupUI(isDate: Bool) {
        isDate ? expireDateSetup() : nil
        aboutSetup(isDate: isDate)
        totalPriceSetup()
    }
}
