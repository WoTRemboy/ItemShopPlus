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
    
    public func configurate(with image: UIImage) {
        itemImageView.image = image
        setupUI()
    }
    
    private func setupUI() {
        addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = .Placeholder.noImage
    }
    
}
