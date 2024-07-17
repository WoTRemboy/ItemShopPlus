//
//  FavouritesFooterReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 12.07.2024.
//

import UIKit

final class FavouritesFooterReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = Texts.FavouritesPage.footerIdentifier
    private var symbolPosition: CurrencySymbolPosition = .left
    private var priceWidthAnchor: NSLayoutConstraint = .init()
    
    // MARK: - UI Elements and Views
    
    private let priceView = CollectionTotalPriceView(frame: .null, price: Texts.ShopGrantedCell.price)
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Methods
    
    public func configurate(price: Int) {
        priceView.changePrice(price: price, animated: false)
        totalPriceSetup(price: price)
    }
    
    public func changePrice(to price: Int) {
        priceWidthAnchor = priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * String(price).count)))
        priceWidthAnchor.isActive = true
        
        UIView.transition(with: priceView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.priceView.changePrice(price: price, animated: false)
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - UI Setups
    
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



