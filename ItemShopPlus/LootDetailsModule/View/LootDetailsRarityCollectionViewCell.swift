//
//  LootDetailsRarityCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.04.2024.
//

import UIKit
import Kingfisher

/// A custom collection view cell for displaying loot items with their rarity
final class LootDetailsRarityCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// A static identifier for reusing the cell in collection views
    static let identifier = Texts.LootDetailsRarityCell.identifier
    /// A task responsible for downloading the item's image asynchronously
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// The label that displays the type of the loot item (e.g., weapon, health)
    private let itemTypeLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// The image view that displays the main image of the loot item
    private let grantedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// The image view that displays the rarity of the loot item (e.g., common, rare)
    private let rarityImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: - Public Configure Method
    
    
    /// Configures the cell with loot item data, including the item's name, type, rarity, and image
    /// - Parameters:
    ///   - name: The name of the loot item
    ///   - type: The type of the loot item (e.g., weapon, health, trap)
    ///   - rarity: The rarity of the loot item
    ///   - image: The URL of the loot item's image
    ///   - video: A flag indicating whether the item has an associated video
    public func configurate(name: String, type: String, rarity: Rarity, image: String, video: Bool) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: grantedImageView, size: CGSize(width: 1024, height: 1024))
        itemTypeLabel.text = type
        rarityImageView.image = SelectingMethods.selectRarity(rarity: rarity)
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and layout constraints for the loot rarity cell
    private func setupUI() {
        addSubview(grantedImageView)
        addSubview(itemTypeLabel)
        addSubview(rarityImageView)
        
        grantedImageView.translatesAutoresizingMaskIntoConstraints = false
        itemTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        rarityImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grantedImageView.topAnchor.constraint(equalTo: topAnchor),
            grantedImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            grantedImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            grantedImageView.heightAnchor.constraint(equalTo: grantedImageView.widthAnchor),
            
            rarityImageView.topAnchor.constraint(equalTo: grantedImageView.bottomAnchor, constant: 10),
            rarityImageView.leadingAnchor.constraint(equalTo: grantedImageView.leadingAnchor),
            rarityImageView.heightAnchor.constraint(equalToConstant: 20),
            rarityImageView.widthAnchor.constraint(equalTo: rarityImageView.heightAnchor, multiplier: 50/36),
            
            itemTypeLabel.centerYAnchor.constraint(equalTo: rarityImageView.centerYAnchor),
            itemTypeLabel.leadingAnchor.constraint(equalTo: rarityImageView.trailingAnchor, constant: 3),
            itemTypeLabel.trailingAnchor.constraint(equalTo: grantedImageView.trailingAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    /// Prepares the cell for reuse by clearing its content and canceling any pending image loading tasks
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        grantedImageView.image = .Placeholder.noImage
        grantedImageView.removeFromSuperview()
        rarityImageView.removeFromSuperview()
    }
}
