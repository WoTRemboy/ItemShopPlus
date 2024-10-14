//
//  FavouritesFooterReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 12.07.2024.
//

import UIKit

/// A reusable view that displays the total price in the Favourites section
final class FavouritesFooterReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    /// The identifier for this reusable view
    static let identifier = Texts.FavouritesPage.footerIdentifier
    /// The position of the currency symbol (e.g., left or right)
    private var symbolPosition: CurrencySymbolPosition = .left
    /// A constraint used to dynamically adjust the width of the price view
    private var priceWidthAnchor: NSLayoutConstraint = .init()
    
    // MARK: - UI Elements and Views
    
    /// A custom view that shows the total price
    private let priceView = CollectionTotalPriceView(frame: .null, price: Texts.ShopGrantedCell.price)
    
    /// A label that displays the "Total" text above the price
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Methods
    
    /// Configures the footer view with the initial price
    /// - Parameter price: The initial price to display
    public func configurate(price: Int) {
        priceView.changePrice(price: price, animated: false)
        totalPriceSetup(price: price)
    }
    
    /// Updates the price displayed in the footer view
    /// - Parameter price: The new price to update
    public func changePrice(to price: Int) {
        priceWidthAnchor = priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * String(price).count)))
        priceWidthAnchor.isActive = true
        
        UIView.transition(with: priceView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.priceView.changePrice(price: price, animated: false)
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - UI Setups
    
    /// Sets up the layout and constraints for the total price label and the price view
    /// - Parameter price: The initial price to be displayed
    private func totalPriceSetup(price: Int) {
        addSubview(totalPriceLabel)
        addSubview(priceView)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceView.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceView.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 25),
        ])
        priceWidthAnchor = priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * String(price).count))) // vBucks icon + price widths
        priceWidthAnchor.isActive = true
    }
}



