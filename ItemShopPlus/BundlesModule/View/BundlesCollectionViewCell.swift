//
//  BundlesCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 20.04.2024.
//

import UIKit
import Kingfisher

/// A custom cell for displaying a bundle item
final class BundlesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The identifier for reuse of the collection view cell
    static let identifier = Texts.BundleCell.identifier
    /// The task responsible for downloading the bundle's image
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// A label displaying the name of the bundle item
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label displaying the price of the bundle item
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// An image view displaying the image of the bundle item
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage16To9
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the provided name, price, and image URL
    /// - Parameters:
    ///   - name: The name of the bundle item
    ///   - price: The price of the bundle item
    ///   - image: The URL of the image to display for the bundle item
    public func configurate(name: String, price: String, image: String) {
        itemNameLabel.text = name
        itemPriceLabel.text = price
        setupUI()
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: itemImageView, size: CGSize(width: UIScreen.main.nativeBounds.width, height: UIScreen.main.nativeBounds.width / 2))
    }
    
    /// Updates the price label with a new price and animates the change if specified
    /// - Parameters:
    ///   - price: The new price to display
    ///   - animated: A boolean indicating whether to animate the price change
    public func priceUpdate(price: String, animated: Bool = true) {
        guard price != Texts.BundleCell.free else { return }
        if animated {
            UIView.transition(with: itemPriceLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.itemPriceLabel.text = price
            }, completion: nil)
        } else {
            self.itemPriceLabel.text = price
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and constraints of the cell
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
    
    /// Prepares the cell for reuse by canceling any ongoing image loading tasks and resetting the image view
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        itemImageView.image = .Placeholder.noImage16To9
    }
}
