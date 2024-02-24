//
//  ShopCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    static let identifier = Texts.ShopMainCell.identifier
    private var imageLoadTask: URLSessionDataTask?
    
    private var images = [String]()
    private var isLoading = false
    
    private var imageViews = [UIImageView]()
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
        
        let attributes: [NSAttributedString.Key: Any] = [          .strikethroughStyle: NSUnderlineStyle.single.rawValue]
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
        
    public func configurate(with images: [String], _ name: String, _ price: Int, _ oldPrice: Int, _ banner: Banner, grantedCount: Int, _ width: CGFloat) {
        self.images = images
        
        setupImageCarousel(images: images, banner: banner, grantedCount: grantedCount, cellWidth: width)
        contentSetup(name: name, price: price, oldPrice: oldPrice, count: grantedCount)
        setupUI()
        
        if banner == .sale {
            itemOldPriceSetup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * scrollView.bounds.width, height: scrollView.bounds.height)
        let indentSize = scrollView.frame.height / 9
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: indentSize, bottom: 0, right: indentSize)
    }
    
    private func contentSetup(name: String, price: Int, oldPrice: Int, count: Int) {
        itemNameLabel.text = name
        itemPriceLabel.text = String(price)
        itemOldPriceLabel.text = String(oldPrice)
        grantedItemsImageView.image = UIImage(systemName: "\(count).circle.fill", withConfiguration: UIImage.SymbolConfiguration(
            paletteColors: [.white, .IconColors.backgroundPages ?? .orange]))
    }
    
    private func setupImageCarousel(images: [String], banner: Banner, grantedCount: Int, cellWidth: CGFloat) {
        scrollView.delegate = self
        
        for (index, imageURL) in images.enumerated() {
            let imageView = UIImageView()
            imageView.image = .Placeholder.noImage
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
            
            if index == 0 {
                imageLoadTask = ImageLoader.loadAndShowImage(from: imageURL, to: imageView)
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
        
        if banner != .null, banner != .sale {
            bannerImageViewSetup(banner: banner, cellWidth: cellWidth)
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
        
        switch banner {
        case .new:
            bannerImageView.image = .ShopMain.new
        case .sale:
            bannerImageView.image = .ShopMain.sale
        case .emote:
            bannerImageView.image = .ShopMain.emote
        case .pickaxe:
            bannerImageView.image = .ShopMain.pickaxe
        default:
            bannerImageView.image = .ShopMain.new
        }
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            bannerImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            bannerImageView.heightAnchor.constraint(equalToConstant: cellWidth / 5),
            bannerImageView.widthAnchor.constraint(equalTo: bannerImageView.heightAnchor, multiplier: 1.5)
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
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceImageView.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        ])
    }
    
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        loadImagesForOnscreenCells()
    }
    
    private func loadImagesForOnscreenCells() {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        for (index, imageView) in imageViews.enumerated() {
            if visibleRect.intersects(imageView.frame) && imageView.image == .Placeholder.noImage, !isLoading {
                
                isLoading = true
                let imageURL = images[index]
                
                imageLoadTask = ImageLoader.loadImage(urlString: imageURL) { image in
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
