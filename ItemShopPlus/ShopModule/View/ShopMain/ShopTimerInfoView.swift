//
//  ShopTimerInfoView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

class ShopTimerInfoView: UIView {
    
    // MARK: - UI Elements and Views
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ShopMain.infoFish
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .body()
        label.textColor = .LabelColors.labelPrimary
        label.text = Texts.ShopPage.rotationInfo
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .title()
        label.textColor = .LabelColors.labelPrimary
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Configure Method
    
    public func setInfoLabelText(text: String) {
        timerLabel.text = text
    }
    
    // MARK: - UI Setup

    private func setupUI() {
        addSubview(infoImageView)
        addSubview(infoLabel)
        addSubview(timerLabel)
        
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoImageView.topAnchor.constraint(equalTo: topAnchor),
            infoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 150 / 812 * UIScreen.main.bounds.height),
            infoImageView.widthAnchor.constraint(equalTo: infoImageView.heightAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 16),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10)
        ])
    }
}
