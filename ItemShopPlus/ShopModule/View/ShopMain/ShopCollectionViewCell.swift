//
//  ShopCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit
import Kingfisher

/// A custom collection view cell for displaying shop items with images, labels, and interactive elements
final class ShopCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    /// The reuse identifier for this cell
    static let identifier = Texts.ShopMainCell.identifier
    /// The image loading task for asynchronous loading
    private var imageLoadTask: DownloadTask?
    
    /// The collection of images for the shop item
    private var images = [ShopItemImage]()
    /// The array of image views for displaying the shop item images
    private var imageViews = [UIImageView]()
    /// Indicates if images are currently being loaded
    private var isLoading = false
    
    // MARK: - UI Elements and Views
    
    /// The image view for displaying the banner
    private let bannerImageView = UIImageView()
    
    /// The scroll view for displaying a carousel of images
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
    
    /// The label for displaying the item name
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemName
        label.textColor = .labelPrimary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label for displaying the item price
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemPrice
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label for displaying the old item price (for sale items)
    private let itemOldPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopPage.itemPrice
        label.textColor = .LabelColors.labelTertiary
        label.font = .footnote()
        label.numberOfLines = 1
        
        // Add strikethrough style to indicate old price
        let attributes: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: label.text ?? "", attributes: attributes)
        label.attributedText = attributedText
        return label
    }()
    
    /// The image view for displaying the item price icon
    private let itemPriceImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.price
        return view
    }()
    
    /// The image view for displaying the number of granted items
    private let grantedItemsImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.granted
        return view
    }()
    
    /// The image view for displaying ability for images swiping
    private let itemPagesImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.pages
        return view
    }()
    
    /// The image view for displaying a video icon
    private let videoImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.video
        return view
    }()
    
    /// The button for toggling the favourite status of the shop item
    internal let favouriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(nil, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Button Press Animation
    
    /// Handles the favourite button press and performs a bounce animation
    /// - Parameter sender: The favourite button being pressed
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
    
    /// Configures the cell with the provided parameters
    /// - Parameters:
    ///   - images: An array of `ShopItemImage` objects for the carousel
    ///   - name: The name of the shop item
    ///   - price: The final price of the shop item
    ///   - oldPrice: The old price of the shop item, used for sale items
    ///   - banner: The banner associated with the item
    ///   - video: A Boolean indicating if the item has an associated video
    ///   - favourite: A Boolean indicating if the item is marked as a favourite
    ///   - grantedCount: The number of granted items associated with the shop item
    ///   - width: The width of the cell for layout purposes
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
    
    /// Sets up the scroll view's content size and layout constraints
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * scrollView.bounds.width, height: scrollView.bounds.height)
        let indentSize = scrollView.frame.height / 9
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: indentSize, bottom: 0, right: indentSize)
    }
    
    // MARK: - UI Setups
    
    /// Configures the labels and image views based on the provided item details
    /// - Parameters:
    ///   - name: The name of the shop item
    ///   - price: The final price of the shop item
    ///   - oldPrice: The old price of the shop item, used for sale items
    ///   - count: The number of granted items
    ///   - favourite: A Boolean indicating if the item is marked as a favourite
    private func contentSetup(name: String, price: Int, oldPrice: Int, count: Int, favourite: Bool) {
        itemNameLabel.text = name
        itemPriceLabel.text = String(price)
        itemOldPriceLabel.text = String(oldPrice)
        grantedItemsImageView.image = UIImage(systemName: "\(count).circle.fill", withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .IconColors.backgroundPages ?? .orange]))
        favouriteButton.setImage(favourite ? .ShopMain.favouriteTrue : .ShopMain.favouriteFalse, for: .normal)
    }
    
    /// Sets up the image carousel with the provided images and additional indicators
    /// - Parameters:
    ///   - images: The images to display in the carousel
    ///   - banner: The banner to display on the first image
    ///   - video: A Boolean indicating if the item has a video
    ///   - grantedCount: The number of granted items
    ///   - cellWidth: The width of the cell for layout purposes
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
    
    // MARK: - Individual UI Element Setup Methods
    
    /// Sets up the item pages indicator view
    /// - Parameter cellWidth: The width of the cell for layout purposes
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
    
    /// Sets up the item pages indicator view
    /// - Parameter cellWidth: The width of the cell for layout purposes
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
    
    /// Sets up the banner image view
    /// - Parameters:
    ///   - banner: The banner to display on the item image
    ///   - cellWidth: The width of the cell for layout purposes
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
    
    /// Sets up the video image view
    /// - Parameter cellWidth: The width of the cell for layout purposes
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
    
    /// Sets up the old price label for sale items
    private func itemOldPriceSetup() {
        addSubview(itemOldPriceLabel)
        itemOldPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemOldPriceLabel.leadingAnchor.constraint(equalTo: itemPriceLabel.trailingAnchor, constant: 5),
            itemOldPriceLabel.bottomAnchor.constraint(equalTo: itemPriceLabel.bottomAnchor)
        ])
    }
    
    /// Sets up the basic UI elements of the cell
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
            // Scroll view constraints setup
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Item name label constraints setup
            itemNameLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 5),
            itemNameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            itemNameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            // Price currency image constraints setup
            itemPriceImageView.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: 5),
            itemPriceImageView.leadingAnchor.constraint(equalTo: itemNameLabel.leadingAnchor),
            itemPriceImageView.heightAnchor.constraint(equalToConstant: 17),
            itemPriceImageView.widthAnchor.constraint(equalTo: itemPriceImageView.heightAnchor),
            
            // Item price label constraints setup
            itemPriceLabel.centerYAnchor.constraint(equalTo: itemPriceImageView.centerYAnchor),
            itemPriceLabel.leadingAnchor.constraint(equalTo: itemPriceImageView.trailingAnchor, constant: 5),
            
            // Favourite button constraints setup
            favouriteButton.centerYAnchor.constraint(equalTo: itemPriceImageView.centerYAnchor),
            favouriteButton.centerXAnchor.constraint(equalTo: trailingAnchor, constant: -17/2),
            favouriteButton.heightAnchor.constraint(equalTo: itemPriceImageView.heightAnchor, multiplier: 2),
            favouriteButton.widthAnchor.constraint(equalTo: favouriteButton.heightAnchor)
        ])
    }
    
    // MARK: - Reusing Preparation
    
    /// Prepares the cell for reuse by resetting its state
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
    
    // MARK: - Networking Methods
    
    /// Loads images for visible cells only
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
