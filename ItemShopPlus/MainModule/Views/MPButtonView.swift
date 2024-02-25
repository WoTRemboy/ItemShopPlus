//
//  MPButtonView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MPButtonView: UIView {
    
    private var buttonType: ButtonType
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
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
    
    init(frame: CGRect, buttonType: ButtonType) {
        self.buttonType = buttonType
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private func buttonContentSetup(buttonType: ButtonType) {
        switch buttonType {
        case .shop:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.shop
            buttonImageView.image = .MainButtons.shop
            selectButton.addTarget(nil, action: #selector(MainPageViewController.shopTransfer), for: .touchUpInside)
        case .news:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.battlePass
            buttonImageView.image = .MainButtons.battlePass
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
        case .tournaments:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.tournaments
            buttonImageView.image = .MainButtons.tournaments
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
        case .quests:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.quests
            buttonImageView.image = .MainButtons.quests
            selectButton.addTarget(nil, action: #selector(MainPageViewController.questsTransfer), for: .touchUpInside)
        case .crew:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.crew
            buttonImageView.image = .MainButtons.crew
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
        case .map:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.map
            buttonImageView.image = .MainButtons.map
            selectButton.addTarget(nil, action: #selector(MainPageViewController.mapTransfer), for: .touchUpInside)
        case .vehicles:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.vehicles
            buttonImageView.image = .MainButtons.vehicles
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
        case .augments:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.augments
            buttonImageView.image = .MainButtons.augments
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
        case .cache:
            buttonLabel.text = Texts.ButtonLabels.MainButtons.cache
            buttonImageView.image = .MainButtons.trash
            selectButton.addTarget(nil, action: #selector(MainPageViewController.clearCache), for: .touchUpInside)
        case .null:
            buttonLabel.text = "??????"
            buttonImageView.image = .MainButtons.question
            selectButton.addTarget(nil, action: #selector(MainPageViewController.sayHi), for: .touchUpInside)
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
