//
//  ShopCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.01.2024.
//

import UIKit

class ShopCollectionReusableView: UICollectionReusableView {
        
    static let identifier = Texts.ShopMainCell.headerIdentifier
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.ShopPage.segmentName
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public func configurate(with title: String) {
        sectionLabel.text = title
        setupUI()
    }
    
    private func setupUI() {
        addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
