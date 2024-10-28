//
//  BundlesDetailsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit
import Kingfisher

/// A custom cell for displaying detailed bundle image
final class BundlesDetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The identifier for reuse of the collection view cell
    static let identifier = Texts.BundleDetailsCell.identifier
    /// The task responsible for downloading the bundle's detailed image
    private var imageLoadTask: DownloadTask?
    
    // MARK: - UI Elements and Views
    
    /// An image view displaying the detailed image of the bundle item
    private let detailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage3To4
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the provided image URL
    /// - Parameter image: The URL of the image to display for the detailed view
    public func configurate(image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: detailsImageView, size: CGSize(width: 1200, height: 1600))
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI elements and constraints of the cell
    private func setupUI() {
        addSubview(detailsImageView)
        detailsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsImageView.topAnchor.constraint(equalTo: topAnchor),
            detailsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailsImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailsImageView.widthAnchor.constraint(equalTo: detailsImageView.heightAnchor, multiplier: 0.75)
        ])
    }
}
