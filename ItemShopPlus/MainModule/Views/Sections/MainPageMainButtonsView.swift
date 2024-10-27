//
//  MainPageMainButtonsView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.06.2024.
//

import UIKit

/// A view that displays the shop, battle pass and stats buttons on the main page
final class MainPageMainButtonsView: UIView {
    
    // MARK: - Properties
    
    /// The shop button
    private let shopButton = MainPageButtonView(buttonType: .shop)
    /// The battle pass button
    private let battlePassButton = MainPageButtonView(buttonType: .battlePass)
    /// The stats button
    private let statsButton = MainPageButtonView(buttonType: .stats)
    
    /// The title label displayed above the buttons
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.Titles.main
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializers
    
    convenience init() {
        self.init(frame: .null)
        
        setupLayout()
        setConstraints()
    }
    
    // MARK: - UI Setup
    
    /// Adds subviews and configures their properties
    private func setupLayout() {
        addSubview(shopButton)
        addSubview(battlePassButton)
        addSubview(statsButton)
        addSubview(titleLabel)
        
        shopButton.translatesAutoresizingMaskIntoConstraints = false
        battlePassButton.translatesAutoresizingMaskIntoConstraints = false
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Sets up the constraints for the subviews
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // Constraints for the title label
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // Constraints for the shop button
            shopButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            shopButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shopButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 16 * 4) / 3),
            shopButton.heightAnchor.constraint(equalTo: shopButton.widthAnchor, constant: 27),
            
            // Constraints for the battle pass button
            battlePassButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            battlePassButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            battlePassButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            battlePassButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            
            // Constraints for the stats button
            statsButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            statsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            statsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor)
        ])
    }
}
