//
//  ShopGrantedView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.01.2024.
//

import UIKit

class ShopGrantedView: UIView {

    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(frame: CGRect, image: String) {
        super.init(frame: frame)
        ImageLoader.loadAndShowImage(from: image, to: itemImageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(itemImageView)
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: topAnchor),
            itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
