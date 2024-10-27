//
//  ShopFavouritesNotificationView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 16.07.2024.
//

import UIKit

/// A view that displays a notification about favourite items in the shop
final class ShopFavouritesNotificationView: UIView {
    
    // MARK: - Views
    
    /// An image view to display the favourites icon
    private let favouriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .MainButtons.favourites
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// A label displaying text related to favourites
    private let favouriteLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.favourites
        label.textColor = .LabelColors.labelNotification
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .null)
        backgroundColor = .BackColors.backNotification
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and their constraints
    private func setupUI() {
        addSubview(favouriteImageView)
        addSubview(favouriteLabel)
        favouriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favouriteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Set up favouriteImageView constraints
            favouriteImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            favouriteImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            favouriteImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            favouriteImageView.widthAnchor.constraint(equalTo: favouriteImageView.heightAnchor),
            
            // Set up favouriteLabel constraints
            favouriteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            favouriteLabel.leadingAnchor.constraint(equalTo: favouriteImageView.trailingAnchor, constant: 16),
            favouriteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
