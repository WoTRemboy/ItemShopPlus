//
//  MPButtonView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

final class MPButtonView: UIView {
    
    private var buttonType: ButtonType
    
    // MARK: - UI Elements and Views
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Placeholder.noText
        label.font = .body()
        label.textColor = .labelPrimary
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpOutside)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    init(frame: CGRect, buttonType: ButtonType) {
        self.buttonType = buttonType
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - UI Setup
    
    private func setupLayout() {
        backgroundColor = .BackColors.backElevated
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.Shadows.primary
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        
        buttonContentSetup(buttonType: buttonType)
        
        addSubview(buttonImageView)
        addSubview(buttonLabel)
        addSubview(selectButton)
    }
    
    private func buttonContentSetup(buttonType: ButtonType) {
        switch buttonType {
        case .shop:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.shop
            buttonImageView.image = .MainButtons.shop
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.shopTransfer), for: .touchUpInside)
        case .battlePass:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.battlePass
            buttonImageView.image = .MainButtons.battlePass
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.battlePassTransfer), for: .touchUpInside)
        case .crew:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.crew
            buttonImageView.image = .MainButtons.crew
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.crewTransfer), for: .touchUpInside)
        case .bundles:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.bundles
            buttonImageView.image = .MainButtons.bundles
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.bundleTransfer), for: .touchUpInside)
        case .lootDetails:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.lootDetails
            buttonImageView.image = .MainButtons.lootDetails
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.lootDetailsTransfer), for: .touchUpInside)
        case .stats:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.stats
            buttonImageView.image = .MainButtons.stats
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.statsTransfer), for: .touchUpInside)
        case .map:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.map
            buttonImageView.image = .MainButtons.map
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.mapTransfer), for: .touchUpInside)
        case .settings:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.settings
            buttonImageView.image = .MainButtons.settings
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.settingTransfer), for: .touchUpInside)
        case .null, .augments, .favourites:
            buttonLabel.text = "??????"
            buttonImageView.image = .MainButtons.question
            selectButton.addTarget(nil, action: #selector(LegacyMainPageViewController.doNothing), for: .touchUpInside)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(17 + 20 + 10)),
            buttonImageView.widthAnchor.constraint(equalTo: buttonImageView.heightAnchor),
            
            buttonLabel.topAnchor.constraint(equalTo: buttonImageView.bottomAnchor, constant: 10),
            buttonLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            selectButton.topAnchor.constraint(equalTo: topAnchor),
            selectButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
