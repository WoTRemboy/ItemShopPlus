//
//  MainPageOtherView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit

final class MainPageOtherView: UIView {

    private let statsButton = MainPageButtonView(buttonType: .stats)
    private let mapButton = MainPageButtonView(buttonType: .map)
    private let armoryButton = MainPageButtonView(buttonType: .lootDetails)
    private let favouritesButton = MainPageButtonView(buttonType: .favourites)
    private let settingsButton = MainPageButtonView(buttonType: .settings)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.Titles.other
        label.numberOfLines = 1
        return label
    }()

    convenience init() {
        self.init(frame: .null)
        
        setupLayout()
        setConstraints()
    }
    
    private func setupLayout() {
        addSubview(statsButton)
        addSubview(mapButton)
        addSubview(armoryButton)
        addSubview(favouritesButton)
        addSubview(settingsButton)
        addSubview(titleLabel)
        
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        armoryButton.translatesAutoresizingMaskIntoConstraints = false
        favouritesButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            statsButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            statsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statsButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -(12 + (UIScreen.main.bounds.width - 68) / 4 + 6)),
            statsButton.heightAnchor.constraint(equalTo: statsButton.widthAnchor, constant: 27),
            
            mapButton.topAnchor.constraint(equalTo: statsButton.topAnchor),
            mapButton.leadingAnchor.constraint(equalTo: statsButton.trailingAnchor, constant: 12),
            mapButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4),
            mapButton.heightAnchor.constraint(equalTo: statsButton.heightAnchor),
            
            armoryButton.topAnchor.constraint(equalTo: statsButton.topAnchor),
            armoryButton.leadingAnchor.constraint(equalTo: mapButton.trailingAnchor, constant: 12),
            armoryButton.widthAnchor.constraint(equalTo: statsButton.widthAnchor),
            armoryButton.heightAnchor.constraint(equalTo: statsButton.heightAnchor),
            
            favouritesButton.topAnchor.constraint(equalTo: statsButton.topAnchor),
            favouritesButton.leadingAnchor.constraint(equalTo: armoryButton.trailingAnchor, constant: 12),
            favouritesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favouritesButton.heightAnchor.constraint(equalTo: statsButton.heightAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: statsButton.bottomAnchor, constant: 10),
            settingsButton.leadingAnchor.constraint(equalTo: statsButton.leadingAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: statsButton.trailingAnchor),
            settingsButton.heightAnchor.constraint(equalTo: statsButton.heightAnchor),
        ])
    }
}
