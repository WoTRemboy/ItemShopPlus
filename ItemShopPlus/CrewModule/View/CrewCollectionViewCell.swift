//
//  CrewCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

class CrewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = Texts.CrewPageCell.identifier
    private var imageLoadTask: URLSessionDataTask?
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.CrewPageCell.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    private let itemTypeLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.CrewPageCell.itemName
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
    
    public func configurate(name: String, type: String, rarity: String, image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: grantedImageView)
        itemNameLabel.text = name
        itemTypeLabel.text = type
        rarityImageView.image = selectRarity(rarity: rarity)
        setupUI()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        grantedImageView.image = .Placeholder.noImage
        grantedImageView.removeFromSuperview()
        rarityImageView.removeFromSuperview()
    }
    
    private func selectRarity(rarity: String) -> UIImage {
        switch rarity {
        case "Common":
            return .ShopGranted.common ?? .grantedCommon
        case "Uncommon":
            return .ShopGranted.uncommon ?? .grantedUncommon
        case "Rare":
            return .ShopGranted.rare ?? .grantedRare
        case "Epic":
            return .ShopGranted.epic ?? .grantedEpic
        case "Legendary":
            return .ShopGranted.legendary ?? .grantedLegendary
        default:
            return .ShopGranted.common ?? .grantedCommon
        }
    }
    
}

