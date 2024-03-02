//
//  ShopGrantedTotalPriceView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

class CollectionTotalPriceView: UIView {
    
    private let priceImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.price
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.numberOfLines = 1
        return label
    }()
    
    init(frame: CGRect, price: String) {
        priceLabel.text = price
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(price: String, currency: CurrencyImage) {
        priceLabel.text = price
        currency == .star ? priceImageView.image = .BattlePass.star : nil
    }
    
    private func setupUI() {
        addSubview(priceImageView)
        addSubview(priceLabel)
        
        priceImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            priceImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            priceImageView.widthAnchor.constraint(equalToConstant: 25),
            priceImageView.heightAnchor.constraint(equalTo: priceImageView.widthAnchor),
            
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceImageView.trailingAnchor, constant: 10)
        ])
    }
}
