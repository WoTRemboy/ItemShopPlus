//
//  MainPageOtherView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit

final class MainPageOtherView: UIView {

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
        addSubview(mapButton)
        addSubview(armoryButton)
        addSubview(favouritesButton)
        addSubview(settingsButton)
        addSubview(titleLabel)
        
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
            
            mapButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            mapButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mapButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -(12 + (UIScreen.main.bounds.width - 68) / 4 + 6)),
            mapButton.heightAnchor.constraint(equalTo: mapButton.widthAnchor, constant: 27),
            
            armoryButton.topAnchor.constraint(equalTo: mapButton.topAnchor),
            armoryButton.leadingAnchor.constraint(equalTo: mapButton.trailingAnchor, constant: 12),
            armoryButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -4),
            armoryButton.heightAnchor.constraint(equalTo: mapButton.heightAnchor),
            
            favouritesButton.topAnchor.constraint(equalTo: mapButton.topAnchor),
            favouritesButton.leadingAnchor.constraint(equalTo: armoryButton.trailingAnchor, constant: 12),
            favouritesButton.widthAnchor.constraint(equalTo: mapButton.widthAnchor),
            favouritesButton.heightAnchor.constraint(equalTo: mapButton.heightAnchor),
            
            settingsButton.topAnchor.constraint(equalTo: mapButton.topAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: favouritesButton.trailingAnchor, constant: 12),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            settingsButton.heightAnchor.constraint(equalTo: mapButton.heightAnchor)
        ])
    }
}
