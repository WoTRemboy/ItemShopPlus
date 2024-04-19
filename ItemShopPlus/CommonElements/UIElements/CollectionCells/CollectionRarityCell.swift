//
//  ShopGrantedCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.01.2024.
//

import UIKit

final class CollectionRarityCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.CollectionCell.identifier
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
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let rarityImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.video
        return view
    }()
    
    // MARK: - Public Configure Method
    
    public func configurate(name: String, type: String, rarity: Rarity, image: String, video: Bool) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: grantedImageView)
        itemNameLabel.text = name
        itemTypeLabel.text = type
        rarityImageView.image = SelectingMethods.selectRarity(rarity: rarity)
        video ? videoBannerImageViewSetup() : nil
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func videoBannerImageViewSetup() {
        grantedImageView.addSubview(videoImageView)
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: grantedImageView.topAnchor, constant: -2),
            videoImageView.trailingAnchor.constraint(equalTo: grantedImageView.trailingAnchor, constant: -8),
            videoImageView.heightAnchor.constraint(equalTo: grantedImageView.widthAnchor, multiplier: 1/3),
            videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 1.06)
        ])
    }
    
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
            
            rarityImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            rarityImageView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
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
        videoImageView.removeFromSuperview()
    }
}
