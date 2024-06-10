//
//  MainPageMainButtonsView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.06.2024.
//

import UIKit

class MainPageMainButtonsView: UIView {

    private let shopButton = MainPageButtonView(buttonType: .shop)
    private let battlePassButton = MainPageButtonView(buttonType: .battlePass)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.Titles.main
        label.numberOfLines = 1
        return label
    }()
    
    convenience init() {
        self.init(frame: .null)
        
        setupLayout()
        setConstraints()
    }
    
    private func setupLayout() {
        addSubview(shopButton)
        addSubview(battlePassButton)
        addSubview(titleLabel)
        
        shopButton.translatesAutoresizingMaskIntoConstraints = false
        battlePassButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            shopButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            shopButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            shopButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -20/2),
            shopButton.heightAnchor.constraint(equalTo: shopButton.widthAnchor),
            
            battlePassButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            battlePassButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 20/2),
            battlePassButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            battlePassButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
}
