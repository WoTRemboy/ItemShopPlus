//
//  TimerRemainingView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.03.2024.
//

import UIKit

/// A custom view that displays a title and a countdown or time remaining content, used for a timer display in UI
final class TimerRemainingView: UIView {
    
    // MARK: - UI Elements and Views
    
    /// The label that displays the title of the timer (e.g., "Time Remaining")
    private let remainingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.BattlePassCell.remaining
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label that displays the content of the timer
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
    
    /// Configures the view with a title and content to display
    /// - Parameters:
    ///   - title: The title to display (e.g., "Time Remaining")
    ///   - content: The content to display (e.g., the actual time remaining)
    public func configurate(title: String, content: String) {
        remainingTitleLabel.text = title
        remainingContentLabel.text = content
        
        setupUI()
    }
    
    /// Updates the content of the timer, typically used to refresh the time remaining
    /// - Parameter content: The updated content to display (e.g., updated remaining time)
    public func updateTimer(content: String) {
        remainingContentLabel.text = content
    }
    
    // MARK: - UI Setups
    
    /// Sets up the layout of the UI elements, positioning the title and content labels
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



