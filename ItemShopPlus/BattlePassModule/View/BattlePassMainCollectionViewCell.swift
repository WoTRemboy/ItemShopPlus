//
//  BattlePassMainCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit
import Kingfisher

/// Custom collection view cell used to display a Battle Pass item in the collection view
final class BattlePassMainCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// Identifier used for dequeuing the cell in the collection view
    static let identifier = Texts.BattlePassCell.identifier
    /// Task to handle image downloading and displaying using the Kingfisher library
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// Label displaying the item name
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    /// Label displaying the item type
    private let itemTypeLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// Image view displaying the item's main image
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// Image view to display a banner for free items
    private let freeBannerImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.free
        return view
    }()
    
    /// Image view displaying a star icon as price currency of Battle Pass item
    private let starImageView: UIImageView = {
        let view = UIImageView()
        view.image = .BattlePass.star
        return view
    }()
    
    /// Image view displaying a video icon if the item has a related video
    private let videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.video
        return view
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the given Battle Pass item data
    /// - Parameters:
    ///   - name: The name of the item
    ///   - type: The type of the item
    ///   - image: URL string of the item's image
    ///   - payType: The type of payment required to unlock the item (e.g., free or paid)
    ///   - video: Boolean indicating whether the item has a related video
    public func configurate(name: String, type: String, image: String, payType: PayType, video: Bool) {
        itemNameLabel.text = name
        itemTypeLabel.text = type
        
        // Display the "free" banner if the item is a free item
        payType == .free ? freeBannerViewSetup() : nil
        // Display the video icon if the item has a video
        video ? videoImageViewSetup() : nil
        
        setupUI()
        // Loading and displaying the item image asynchronously using Kingfisher
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: itemImageView, size: CGSize(width: UIScreen.main.nativeBounds.width / 2, height: UIScreen.main.nativeBounds.width / 2))
    }
    
    // MARK: - UI Setup
    
    /// Sets up the position and layout of the "free" banner view on the item image
    private func freeBannerViewSetup() {
        itemImageView.addSubview(freeBannerImageView)
        freeBannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            freeBannerImageView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 4),
            freeBannerImageView.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor, constant: 8),
            freeBannerImageView.widthAnchor.constraint(equalTo: freeBannerImageView.heightAnchor, multiplier: 0.96),
            freeBannerImageView.heightAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 1/3.5)
        ])
    }
    
    /// Sets up the position and layout of the video icon view on the item image
    private func videoImageViewSetup() {
        itemImageView.addSubview(videoImageView)
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 10),
            videoImageView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: -10),
            videoImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor, multiplier: 1/8),
            videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 1.06)
        ])
    }
    
    /// Sets up the initial UI layout and position of all main elements in the cell
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
    
    /// Prepares the cell for reuse by resetting its content and removing subviews
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancels any ongoing image loading task
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        
        // Removes subviews that may have been added in the `configurate` method
        itemImageView.image = .Placeholder.noImage
        freeBannerImageView.removeFromSuperview()
        starImageView.removeFromSuperview()
        videoImageView.removeFromSuperview()
    }
}


