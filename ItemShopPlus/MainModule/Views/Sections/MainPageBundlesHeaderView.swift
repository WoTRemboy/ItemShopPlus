//
//  MainPageBundlesHeaderView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit

class MainPageBundlesHeaderView: UIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.ButtonLabels.MainButtons.bundles
        label.numberOfLines = 1
        return label
    }()
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .MainButtons.chevron
        return imageView
    }()
    
    private let allButton: UIButton = {
        let button = UIButton(type: .system)
        let text = Texts.ShopPage.allMenu
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.title() ?? .systemFont(ofSize: 25),
            .foregroundColor: UIColor.LabelColors.labelPrimary ?? .labelPrimary
        ]
        let attributedText = NSMutableAttributedString(string: text, attributes: textAttributes)
        
        if let chevronImage = UIImage.MainButtons.chevron {
            let chevronAttachment = NSTextAttachment()
            chevronAttachment.image = chevronImage
            chevronAttachment.bounds = CGRect(x: 0, y: -1, width: chevronImage.size.width, height: chevronImage.size.height)
            let chevronAttributedString = NSAttributedString(attachment: chevronAttachment)
            
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(chevronAttributedString)
        }
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(nil, action: #selector(MainPageViewController.bundleTransfer), for: .touchUpInside)
        return button
    }()
    
    convenience init() {
        self.init(frame: .null)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(title)
        addSubview(allButton)
        title.translatesAutoresizingMaskIntoConstraints = false
        allButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            allButton.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            allButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
}
