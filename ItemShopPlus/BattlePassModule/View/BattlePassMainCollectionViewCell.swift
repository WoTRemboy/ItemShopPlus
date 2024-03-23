//
//  BattlePassMainCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit

final class BattlePassMainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.BattlePassCell.identifier
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
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let freeBannerImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.free
        return view
    }()
    
    private let starImageView: UIImageView = {
        let view = UIImageView()
        view.image = .BattlePass.star
        return view
    }()
    
    // MARK: - Public Configure Method
    
    public func configurate(name: String, type: String, image: String, payType: PayType) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: itemImageView)
        itemNameLabel.text = name
        itemTypeLabel.text = type
        payType == .free ? freeBannerViewSetup() : nil
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func freeBannerViewSetup() {
        itemImageView.addSubview(freeBannerImageView)
        freeBannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            freeBannerImageView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 12),
            freeBannerImageView.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: 12),
            freeBannerImageView.widthAnchor.constraint(equalTo: freeBannerImageView.heightAnchor, multiplier: 1.5),
            freeBannerImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupUI() {
        addSubview(itemImageView)
        addSubview(itemNameLabel)
        addSubview(itemTypeLabel)
        addSubview(starImageView)
        
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            
            itemTypeLabel.centerYAnchor.constraint(equalTo: starImageView.centerYAnchor),
            itemTypeLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 3),
            itemTypeLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor),
            
            starImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 2),
            starImageView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            starImageView.heightAnchor.constraint(equalToConstant: 17),
            starImageView.widthAnchor.constraint(equalTo: starImageView.heightAnchor, multiplier: 291/253)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        itemImageView.image = .Placeholder.noImage
        freeBannerImageView.removeFromSuperview()
        starImageView.removeFromSuperview()
    }
}


