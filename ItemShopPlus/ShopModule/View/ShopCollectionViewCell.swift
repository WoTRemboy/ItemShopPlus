//
//  ShopCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    static let identifier = Texts.ShopMainCell.identifier
    private var imageViews = [UIImageView]()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.bounces = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.indicatorStyle = .white
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
    
    private let itemPriceImageView: UIImageView = {
        let view = UIImageView()
        view.image = .ShopMain.price
        return view
    }()
    
    public func configurate(with images: [String], _ name: String, _ price: Int, _ width: CGFloat) {
        setupImageCarousel(with: images, cellWidth: width)
        itemNameLabel.text = name
        itemPriceLabel.text = String(price)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = CGSize(width: CGFloat(imageViews.count) * scrollView.bounds.width, height: scrollView.bounds.height)
        let indentSize = scrollView.frame.height / 9
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: indentSize, bottom: 0, right: indentSize)
    }
    
    private func setupImageCarousel(with images: [String], cellWidth: CGFloat) {
        scrollView.delegate = self
        
        for (index, imageURL) in images.enumerated() {
            let imageView = UIImageView()
            imageView.image = .Placeholder.noImage
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
            ImageLoader.loadAndShowImage(from: imageURL, to: imageView)

            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * cellWidth),
            ])
        }
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
            itemPriceLabel.trailingAnchor.constraint(equalTo: itemNameLabel.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        for imageView in imageViews {
            imageView.removeFromSuperview()
        }
        imageViews.removeAll()
    }
}
