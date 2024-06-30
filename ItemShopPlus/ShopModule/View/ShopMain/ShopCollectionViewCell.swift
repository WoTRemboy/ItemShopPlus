//
//  ShopCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit
import Kingfisher

final class ShopCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = Texts.ShopMainCell.identifier
    private var imageLoadTask: DownloadTask?
    
    private var images = [ShopItemImage]()
    private var imageViews = [UIImageView]()
    private var isLoading = false
    
    // MARK: - UI Elements and Views
    
    private let bannerImageView = UIImageView()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.indicatorStyle = .white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemPrice
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let itemOldPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemPrice
        label.textColor = .LabelColors.labelTertiary
        label.font = .footnote()
        label.numberOfLines = 1
        
        let attributes: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes)
        label.attributedText = attributedText
        return label
    }()
    
    private let itemPriceImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.price
        return view
    }()
    
    private let grantedItemsImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.granted
        return view
    }()
    
    private let itemPagesImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.pages
        return view
    }()
    
    private let videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.video
        return view
    }()
    
    internal let favouriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Button Press Animation
    
    @objc private func favouriteButtonPressed(sender: UIButton) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
        
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.0]
        bounceAnimation.keyTimes = [0.0, 0.3, 0.7, 1.0]
        bounceAnimation.duration = 0.3

        sender.layer.add(bounceAnimation, forKey: "bounce")

        UIView.transition(with: sender, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if sender.currentImage == .ShopMain.favouriteFalse {
                sender.setImage(.ShopMain.favouriteTrue, for: .normal)
            } else {
                sender.setImage(.ShopMain.favouriteFalse, for: .normal)
            }
        }, completion: nil)
    }
    
    // MARK: - Public Configure Method
        
    public func configurate(with images: [ShopItemImage], _ name: String, _ price: Int, _ oldPrice: Int, _ banner: Banner, _ video: Bool, favourite: Bool, grantedCount: Int, _ width: CGFloat) {
        self.images = images
        setupImageCarousel(images: images, banner: banner, video: video, grantedCount: grantedCount, cellWidth: width)
        contentSetup(name: name, price: price, oldPrice: oldPrice, count: grantedCount, favourite: favourite)
        setupUI()
        
        if banner == .sale {
            itemOldPriceSetup()
        }
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * scrollView.bounds.width, height: scrollView.bounds.height)
        let indentSize = scrollView.frame.height / 9
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: indentSize, bottom: 0, right: indentSize)
    }
    
    // MARK: - UI Setups
    
    private func contentSetup(name: String, price: Int, oldPrice: Int, count: Int, favourite: Bool) {
        itemNameLabel.text = name
        itemPriceLabel.text = String(price)
        itemOldPriceLabel.text = String(oldPrice)
        grantedItemsImageView.image = UIImage(systemName: "\(count).circle.fill", withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .IconColors.backgroundPages ?? .orange]))
        favouriteButton.setImage(favourite ? .ShopMain.favouriteTrue : .ShopMain.favouriteFalse, for: .normal)
    }
    
    private func setupImageCarousel(images: [ShopItemImage], banner: Banner, video: Bool, grantedCount: Int, cellWidth: CGFloat) {
        scrollView.delegate = self
        
        for (index, imageURL) in images.enumerated() {
            let imageView = UIImageView()
            imageView.image = .Placeholder.noImage
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
            
            if index == 0 {
                imageLoadTask = ImageLoader.loadAndShowImage(from: imageURL.image, to: imageView, size: CGSize(width: UIScreen.main.nativeBounds.width / 2, height: UIScreen.main.nativeBounds.width / 2))
            }
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * cellWidth),
            ])
        }
        
        if grantedCount > 1 {
            grantedItemsImageViewSetup(cellWidth: cellWidth)
        }
        if images.count > 1 {
            itemPagesImageViewSetup(cellWidth: cellWidth)
            scrollView.showsHorizontalScrollIndicator = true
        }
        if banner == .new {
            bannerImageViewSetup(banner: banner, cellWidth: cellWidth)
        }
        if video {
            videoImageViewSetup(cellWidth: cellWidth)
        }
    }
    
    private func grantedItemsImageViewSetup(cellWidth: CGFloat) {
        scrollView.addSubview(grantedItemsImageView)
        grantedItemsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            grantedItemsImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: cellWidth - 12),
            grantedItemsImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 12),
            grantedItemsImageView.widthAnchor.constraint(equalToConstant: cellWidth / 7),
            grantedItemsImageView.heightAnchor.constraint(equalTo: grantedItemsImageView.widthAnchor)
        ])
    }
    
    private func itemPagesImageViewSetup(cellWidth: CGFloat) {
        scrollView.addSubview(itemPagesImageView)
        itemPagesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemPagesImageView.bottomAnchor.constraint(equalTo: scrollView.topAnchor, constant: cellWidth - 12),
            itemPagesImageView.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: cellWidth - 12),
            itemPagesImageView.widthAnchor.constraint(equalToConstant: cellWidth / 7),
            itemPagesImageView.heightAnchor.constraint(equalTo: itemPagesImageView.widthAnchor)
        ])
    }
    
    private func bannerImageViewSetup(banner: Banner, cellWidth: CGFloat) {
        scrollView.addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        bannerImageView.image = SelectingMethods.selectBanner(banner: banner)

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            bannerImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            bannerImageView.heightAnchor.constraint(equalToConstant: cellWidth / 5),
            bannerImageView.widthAnchor.constraint(equalTo: bannerImageView.heightAnchor, multiplier: 1.5)
        ])
    }
    
    private func videoImageViewSetup(cellWidth: CGFloat) {
        scrollView.addSubview(videoImageView)
        videoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            videoImageView.trailingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: cellWidth - 10),
            videoImageView.heightAnchor.constraint(equalToConstant: cellWidth / 8),
            videoImageView.widthAnchor.constraint(equalTo: videoImageView.heightAnchor, multiplier: 1.06)
        ])
    }
    
    private func itemOldPriceSetup() {
        addSubview(itemOldPriceLabel)
        itemOldPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemOldPriceLabel.leadingAnchor.constraint(equalTo: itemPriceLabel.trailingAnchor, constant: 5),
            itemOldPriceLabel.bottomAnchor.constraint(equalTo: itemPriceLabel.bottomAnchor)
        ])
    }
    
    private func setupUI() {
        addSubview(scrollView)
        addSubview(itemNameLabel)
        addSubview(itemPriceImageView)
        addSubview(itemPriceLabel)
        addSubview(favouriteButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceImageView.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            itemNameLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            itemPriceImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 5),
            itemPriceImageView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemPriceImageView.heightAnchor.constraint(equalToConstant: 17),
            itemPriceImageView.widthAnchor.constraint(equalTo: itemPriceImageView.heightAnchor),
            
            itemPriceLabel.centerYAnchor.constraint(equalTo: itemPriceImageView.centerYAnchor),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemPriceImageView.trailingAnchor, constant: 5),
            
            favouriteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            favouriteButton.topAnchor.constraint(equalTo: itemPriceImageView.topAnchor),
            favouriteButton.heightAnchor.constraint(equalTo: itemPriceImageView.heightAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        scrollView.setContentOffset(.zero, animated: false)
        scrollView.showsHorizontalScrollIndicator = false
        
        for imageView in imageViews {
            imageView.image = .Placeholder.noImage
            imageView.removeFromSuperview()
        }
        imageViews.removeAll()
        itemOldPriceLabel.removeFromSuperview()
        bannerImageView.removeFromSuperview()
        grantedItemsImageView.removeFromSuperview()
        itemPagesImageView.removeFromSuperview()
        videoImageView.removeFromSuperview()
        favouriteButton.removeFromSuperview()
    }
    
    // MARK: - Networking?
    
    private func loadImagesForOnscreenCells() {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        for (index, imageView) in imageViews.enumerated() {
            if visibleRect.intersects(imageView.frame) && imageView.image == .Placeholder.noImage, !isLoading {
                
                isLoading = true
                let imageURL = images[index]
                
                imageLoadTask = ImageLoader.loadImage(urlString: imageURL.image, size: CGSize(width: UIScreen.main.nativeBounds.width / 2, height: UIScreen.main.nativeBounds.width / 2)) { image in
                    DispatchQueue.main.async {
                        imageView.alpha = 0.5
                        if let image = image {
                            imageView.image = image
                        }
                        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                            imageView.alpha = 1.0
                        }, completion: nil)
                    }
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ShopCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        loadImagesForOnscreenCells()
    }
}
