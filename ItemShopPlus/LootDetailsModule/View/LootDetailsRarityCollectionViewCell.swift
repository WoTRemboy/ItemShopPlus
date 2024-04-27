//
//  LootDetailsRarityCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.04.2024.
//

import UIKit
import Kingfisher

final class LootDetailsRarityCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.LootDetailsRarityCell.identifier
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    private let itemTypeLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let grantedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rarityImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: - Public Configure Method
    
    public func configurate(name: String, type: String, rarity: Rarity, image: String, video: Bool) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: grantedImageView, size: CGSize(width: 1024, height: 1024))
        itemTypeLabel.text = type
        rarityImageView.image = SelectingMethods.selectRarity(rarity: rarity)
        setupUI()
    }
    
    // MARK: - UI Setup
    
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
            
            itemTypeLabel.centerYAnchor.constraint(equalTo: rarityImageView.centerYAnchor),
            itemTypeLabel.leadingAnchor.constraint(equalTo: rarityImageView.trailingAnchor, constant: 3),
            itemTypeLabel.trailingAnchor.constraint(equalTo: grantedImageView.trailingAnchor),
            
            rarityImageView.topAnchor.constraint(equalTo: grantedImageView.bottomAnchor, constant: 5),
            rarityImageView.leadingAnchor.constraint(equalTo: grantedImageView.leadingAnchor),
            rarityImageView.heightAnchor.constraint(equalToConstant: 25),
            rarityImageView.widthAnchor.constraint(equalTo: rarityImageView.heightAnchor, multiplier: 291/253)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        grantedImageView.image = .Placeholder.noImage
        grantedImageView.removeFromSuperview()
        rarityImageView.removeFromSuperview()
    }
}
