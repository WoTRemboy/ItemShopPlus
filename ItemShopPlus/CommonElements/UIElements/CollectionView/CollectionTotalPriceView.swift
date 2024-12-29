//
//  ShopGrantedTotalPriceView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

/// A custom view that displays the total price of an item with an associated currency image (e.g., vBucks, stars)
final class CollectionTotalPriceView: UIView {
    
    // MARK: - UI Elements
    
    private var type: CurrencyImage = .vbucks
    
    /// An image view that displays the currency image (e.g., vBucks, stars)
    private let priceImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.price
        return view
    }()
    
    /// A label that displays the price value
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view with a frame and an initial price value
    /// - Parameters:
    ///   - frame: The frame of the view
    ///   - price: The initial price text to display
    init(frame: CGRect, price: String) {
        priceLabel.text = price
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurate Methods
    
    /// Configures the price label and currency image
    /// - Parameters:
    ///   - price: The updated price text
    ///   - currency: The currency type (e.g., vBucks or stars) to update the currency image
    public func configurate(price: String, currency: CurrencyImage) {
        priceLabel.text = price
        type = currency
        type == .star ? priceImageView.image = .BattlePass.star : nil
        
        setupUI()
    }
    
    /// Updates the price with an optional animation
    /// - Parameters:
    ///   - price: The new price to display
    ///   - animated: Whether to animate the price change
    public func changePrice(price: Int, animated: Bool) {
        UIView.transition(with: priceLabel, duration: animated ? 0.3 : 0, options: .transitionFlipFromBottom, animations: {
            self.priceLabel.text = String(price)
        }, completion: nil)
    }
    
    // MARK: - Setup Method
    
    /// Sets up the layout and constraints for the view's subviews
    private func setupUI() {
        addSubview(priceImageView)
        addSubview(priceLabel)
        
        priceImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            priceImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceImageView.heightAnchor.constraint(equalToConstant: 25),
            priceImageView.widthAnchor.constraint(equalTo: priceImageView.heightAnchor, multiplier: type == .vbucks ? 1 : 48/40),
            
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceImageView.trailingAnchor, constant: 10)
        ])
    }
}
