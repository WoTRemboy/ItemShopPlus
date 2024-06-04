//
//  MainPageBundlesCollectionCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit
import Kingfisher

class MainPageBundlesCollectionCell: UICollectionViewCell {
    
    static let identifier = Texts.Titles.bundlesIdentifier
    private var imageLoadTask: DownloadTask?
    
    private let bundleImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public func configurate(image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: bundleImageView, size: CGSize(width: 500, height: 500))
        setupUI()
    }
    
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
    
    override func prepareForReuse() {
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        bundleImageView.image = .Placeholder.noImage
    }
}
