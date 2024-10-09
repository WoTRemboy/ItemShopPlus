//
//  MainPageBundlesCollectionCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit
import Kingfisher

/// A collection view cell that displays bundle images on the main page
final class MainPageBundlesCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The reuse identifier for the cell
    static let identifier = Texts.Titles.bundlesIdentifier
    /// The task responsible for loading the image
    private var imageLoadTask: DownloadTask?
    
    /// The image view that displays the bundle image
    private let bundleImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Configuration
    
    /// Configures the cell with the provided image URL string
    /// - Parameter image: The URL string of the image to display
    public func configurate(image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: bundleImageView, size: CGSize(width: 500, height: 500))
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the user interface elements and constraints
    private func setupUI() {
        addSubview(bundleImageView)
        bundleImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bundleImageView.topAnchor.constraint(equalTo: topAnchor),
            bundleImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bundleImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bundleImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Prepares the cell for reuse by canceling image loading tasks and resetting the image
    override func prepareForReuse() {
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        bundleImageView.image = .Placeholder.noImage
    }
}
