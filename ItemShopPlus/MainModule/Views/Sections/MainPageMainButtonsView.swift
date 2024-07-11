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
    private let statsButton = MainPageButtonView(buttonType: .stats)
    
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
        addSubview(statsButton)
        addSubview(titleLabel)
        
        shopButton.translatesAutoresizingMaskIntoConstraints = false
        battlePassButton.translatesAutoresizingMaskIntoConstraints = false
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        shopButton.backgroundColor = .red
//        statsButton.backgroundColor = .yellow
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            shopButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            shopButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shopButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 16 * 4) / 3),
            shopButton.heightAnchor.constraint(equalTo: shopButton.widthAnchor, constant: 27),
            
            battlePassButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            battlePassButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            battlePassButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            battlePassButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            
            statsButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            statsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            statsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor)
        ])
    }
}
