//
//  TimerRemainingView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.03.2024.
//

import UIKit

class TimerRemainingView: UIView {
    
    // MARK: - UI Elements and Views
    
    private let remainingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.BattlePassCell.remaining
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    private let remainingContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.BattlePassCell.remaining
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Methods
    
    public func configurate(title: String, content: String) {
        remainingTitleLabel.text = title
        remainingContentLabel.text = content
        
        setupUI()
    }
    
    public func updateTimer(content: String) {
        remainingContentLabel.text = content
    }
    
    // MARK: - UI Setups
    
    private func setupUI() {
        addSubview(remainingTitleLabel)
        addSubview(remainingContentLabel)
        remainingTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        remainingContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            remainingTitleLabel.topAnchor.constraint(equalTo: topAnchor),
            remainingTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            remainingContentLabel.topAnchor.constraint(equalTo: remainingTitleLabel.bottomAnchor, constant: 3),
            remainingContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            remainingContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}



