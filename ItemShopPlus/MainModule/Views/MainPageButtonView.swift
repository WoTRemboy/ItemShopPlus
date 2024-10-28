//
//  MainPageButtonView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.06.2024.
//

import UIKit

/// A custom view representing a button on the main page
final class MainPageButtonView: UIView {
    
    // MARK: - Properties
    
    /// The type of the button
    private var buttonType: ButtonType
    
    // MARK: - UI Elements
    
    /// The image view for the button
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The display label for the button
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Placeholder.noText
        label.font = .lightFootnote()
        label.textColor = .labelPrimary
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// The button used for user interaction
    private let selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(.clear, for: .normal)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(frame: CGRect, buttonType: ButtonType) {
        self.buttonType = buttonType
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializer with button type
    /// - Parameter buttonType: ButtonType to define button properties
    convenience init(buttonType: ButtonType) {
        self.init(frame: .null, buttonType: buttonType)
        
        setupLayout()
        setConstraints()
    }

    // MARK: - Actions
    
    /// Handles the touch down event on the button to provide a visual feedback
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    /// Handles the touch up event on the button to provide a visual feedback
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the layout and appearance of the view
    private func setupLayout() {
        layer.shadowColor = UIColor.Shadows.primary
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        buttonContentSetup(buttonType: buttonType)
        
        addSubview(buttonImageView)
        addSubview(buttonLabel)
        addSubview(selectButton)
    }
    
    /// Configures the button content based on the button type
    /// - Parameter buttonType: ButtonType to define button properties
    private func buttonContentSetup(buttonType: ButtonType) {
        switch buttonType {
        case .shop:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.shop, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.shop
            buttonLabel.font = .body()
            buttonImageView.image = .MainButtons.shop
            selectButton.addTarget(nil, action: #selector(MainPageViewController.shopTransfer), for: .touchUpInside)
        case .battlePass:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.battlePass, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.battlePass
            buttonLabel.font = .body()
            buttonImageView.image = .MainButtons.battlePass
            selectButton.addTarget(nil, action: #selector(MainPageViewController.battlePassTransfer), for: .touchUpInside)
        case .crew:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.crew, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.crew
            buttonImageView.image = .MainButtons.crew
            selectButton.addTarget(nil, action: #selector(MainPageViewController.crewTransfer), for: .touchUpInside)
        case .bundles:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.bundles
            buttonImageView.image = .MainButtons.bundles
            selectButton.addTarget(nil, action: #selector(MainPageViewController.bundleTransfer), for: .touchUpInside)
        case .lootDetails:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.lootDetails, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.lootDetails
            buttonImageView.image = .MainButtons.lootDetails
            selectButton.addTarget(nil, action: #selector(MainPageViewController.lootDetailsTransfer), for: .touchUpInside)
        case .stats:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.stats, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.stats
            buttonLabel.font = .body()
            buttonImageView.image = .MainButtons.stats
            selectButton.addTarget(nil, action: #selector(MainPageViewController.statsTransfer), for: .touchUpInside)
        case .map:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.map, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.map
            buttonImageView.image = .MainButtons.map
            selectButton.addTarget(nil, action: #selector(MainPageViewController.mapTransfer), for: .touchUpInside)
        case .favourites:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.favourites, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.favourites
            buttonImageView.image = .MainButtons.favourites
            selectButton.addTarget(nil, action: #selector(MainPageViewController.favouritesTransfer), for: .touchUpInside)
        case .settings:
            selectButton.setTitle(Texts.ButtonLabels.MainButtons.settings, for: .normal)
            buttonLabel.text = Texts.ButtonLabels.MainButtons.settings
            buttonImageView.image = .MainButtons.settings
            selectButton.addTarget(nil, action: #selector(MainPageViewController.settingTransfer), for: .touchUpInside)
        case .augments, .null:
            buttonLabel.text = "??????"
            buttonImageView.image = .MainButtons.question
        }
    }
    
    /// Sets up the constraints for the subviews
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonImageView.topAnchor.constraint(equalTo: topAnchor),
            buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(17 + 10)),
            buttonImageView.widthAnchor.constraint(equalTo: buttonImageView.heightAnchor),
            
            buttonLabel.topAnchor.constraint(equalTo: buttonImageView.bottomAnchor, constant: 10),
            buttonLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            selectButton.topAnchor.constraint(equalTo: topAnchor),
            selectButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
