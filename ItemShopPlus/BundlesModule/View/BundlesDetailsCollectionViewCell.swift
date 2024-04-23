//
//  BundlesDetailsCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit
import Kingfisher

class BundlesDetailsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = Texts.BundleDetailsCell.identifier
    private var imageLoadTask: DownloadTask?
    
    private let detailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Placeholder.noImage
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public func configurate(image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: detailsImageView, size: CGSize(width: 1200, height: 1600))
        setupUI()
    }
    
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
