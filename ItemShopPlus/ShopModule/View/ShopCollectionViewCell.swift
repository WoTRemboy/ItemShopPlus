//
//  ShopCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ShopCollectionViewCell"
    
    private let itemImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.noImage
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemPrice
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    public func configurate(with image: String, _ name: String, _ price: Int) {
        ImageLoader.loadAndShowImage(from: image, to: itemImageView)
        itemNameLabel.text = name
        itemPriceLabel.text = "\(price) VBucks"
        setupUI()
    }
    
    private func setupUI() {
        addSubview(itemImageView)
        addSubview(itemNameLabel)
        addSubview(itemPriceLabel)
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            
            itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 5),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemPriceLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = .Placeholder.noImage
    }
    
}
