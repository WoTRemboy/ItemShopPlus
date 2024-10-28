//
//  BundlesDetailsCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit

/// A reusable view used in the bundle details section, displaying the expiration date, price, and description of a bundle
final class BundlesDetailsCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    /// The identifier for reuse of the collection reusable view
    static let identifier = Texts.BundleDetailsCell.footerIdentifier
    /// The position of the currency symbol (either left or right of the price)
    private var symbolPosition: CurrencySymbolPosition = .left
    
    // MARK: - UI Elements and Views
    
    /// A view displaying the expiration date of the bundle
    private let expiryDate = CollectionParametersRowView(frame: .null, title: Texts.BundleDetailsCell.expiryDate, content: Texts.BundleDetailsCell.expiryDateText)
    
    /// A label displaying the price of the bundle
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// A label displaying the title for the "About" section
    private let aboutTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.BundleDetailsCell.about
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label displaying the content of the "About" section
    private let aboutContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.BundleDetailsCell.aboutText
        label.textColor = .labelPrimary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// A separator line between sections
    private let aboutSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    /// A label displaying the header of the bundle total price
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Methods
    
    /// Configures the view with the provided price, description, about text, and expiration date
    /// - Parameters:
    ///   - price: The price of the bundle
    ///   - description: A brief description of the bundle
    ///   - about: Additional details about the bundle
    ///   - expireDate: The expiration date of the bundle, if available
    public func configurate(price: BundlePrice, description: String, about: String, expireDate: Date?) {
        changePrice(price: price, firstTime: true)
        aboutContentLabel.text = about
        if let expireDate {
            expiryDate.configurate(content: DateFormating.dateFormatterDefault(date: expireDate))
        }
        
        setupUI(isDate: expireDate != nil)
    }
    
    /// Updates the price displayed in the view, with an option to animate the transition
    /// - Parameters:
    ///   - price: The new price to display
    ///   - firstTime: Whether this is the first time the view was shown
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
    
    /// Sets up the UI for the expiration date section
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
    
    /// Sets up the UI for the "About" section
    /// - Parameter isDate: Whether the bundle has an expiration date
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
    
    /// Sets up the UI for the total price section
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
    
    /// Sets up the UI based on whether the bundle has an expiration date
    /// - Parameter isDate: Whether the bundle has an expiration date
    private func setupUI(isDate: Bool) {
        isDate ? expireDateSetup() : nil
        aboutSetup(isDate: isDate)
        totalPriceSetup()
    }
}
