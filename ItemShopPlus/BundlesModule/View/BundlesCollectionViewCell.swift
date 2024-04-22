//
//  BundlesCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 20.04.2024.
//

import UIKit

final class BundlesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.BundleCell.identifier
    private var imageLoadTask: URLSessionDataTask?
    
    // MARK: - UI Elements and Views
    
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
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public Configure Method
    
    public func configurate(name: String, price: String, image: String) {
        itemNameLabel.text = name
        itemPriceLabel.text = price
        setupUI()
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: itemImageView, size: CGSize(width: UIScreen.main.nativeBounds.width, height: UIScreen.main.nativeBounds.width / 2))
    }
    
    public func priceUpdate(price: String) {
        guard price != Texts.BundleCell.free else { return }
        UIView.transition(with: itemPriceLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
            self.itemPriceLabel.text = price
        }, completion: nil)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(itemImageView)
        addSubview(itemNameLabel)
        addSubview(itemPriceLabel)
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 0.5625),
            
            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            
            itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemPriceLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        itemImageView.image = .Placeholder.noImage
    }
}
