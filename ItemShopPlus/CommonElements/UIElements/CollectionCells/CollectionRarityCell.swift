//
//  ShopGrantedCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.01.2024.
//

import UIKit
import Kingfisher

/// A cell for displaying items with their rarity, type, and an optional video indicator
final class CollectionRarityCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The reuse identifier for the cell
    static let identifier = Texts.CollectionCell.identifier
    /// The task responsible for loading images asynchronously
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// A label displaying the name of the item
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label displaying the type of the item
    private let itemTypeLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// An image view displaying the main image of the item
    private let grantedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// An image view displaying the rarity indicator of the item
    private let rarityImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    /// An image view indicating that the item has a video associated with it
    private let videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.video
        return view
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the given item details
    /// - Parameters:
    ///   - name: The name of the item
    ///   - type: The type of the item
    ///   - rarity: The rarity of the item (e.g., common, rare, epic)
    ///   - image: The URL string of the item's image
    ///   - video: A Boolean value indicating whether the item has a video associated with it
    public func configurate(name: String, type: String, rarity: Rarity, image: String, video: Bool) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: grantedImageView, size: CGSize(width: 1024, height: 1024))
        itemNameLabel.text = name
        itemTypeLabel.text = type
        rarityImageView.image = SelectingMethods.selectRarity(rarity: rarity)
        video ? videoBannerImageViewSetup() : nil
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Adds the video banner to the `grantedImageView` if the item has a video
    private func videoBannerImageViewSetup() {
        grantedImageView.addSubview(videoImageView)
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: grantedImageView.topAnchor, constant: 10),
            videoImageView.trailingAnchor.constraint(equalTo: grantedImageView.trailingAnchor, constant: -10),
            videoImageView.heightAnchor.constraint(equalTo: grantedImageView.widthAnchor, multiplier: 1/8),
            videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 1.06)
        ])
    }
    
    /// Sets up the layout of the UI elements in the cell
    private func setupUI() {
        addSubview(grantedImageView)
        addSubview(itemNameLabel)
        addSubview(itemTypeLabel)
        addSubview(rarityImageView)
        
        grantedImageView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grantedImageView.topAnchor.constraint(equalTo: topAnchor),
            grantedImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            grantedImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            grantedImageView.heightAnchor.constraint(equalTo: grantedImageView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: grantedImageView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: grantedImageView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: grantedImageView.trailingAnchor),
            
            itemTypeLabel.centerYAnchor.constraint(equalTo: rarityImageView.centerYAnchor),
            itemTypeLabel.leadingAnchor.constraint(equalTo: rarityImageView.trailingAnchor, constant: 3),
            itemTypeLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor),
            
            rarityImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 5),
            rarityImageView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            rarityImageView.heightAnchor.constraint(equalToConstant: 20),
            rarityImageView.widthAnchor.constraint(equalTo: rarityImageView.heightAnchor, multiplier: 50/36)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    /// Prepares the cell for reuse by cancelling image load tasks and resetting the views
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        grantedImageView.image = .Placeholder.noImage
        grantedImageView.removeFromSuperview()
        rarityImageView.removeFromSuperview()
        videoImageView.removeFromSuperview()
    }
}
