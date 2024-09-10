//
//  EmptyView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.01.2024.
//

import UIKit

final class EmptyView: UIView {
    
    // MARK: - Properties & Initialization
    
    private let type: EmptyViewType
    
    private var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    private var content: String? = nil {
        didSet {
            contentLabel.text = content
        }
    }
    
    private var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    private var aspectRatio: CGFloat {
        guard let trueImage = image else { return 1 }
        let ratio = trueImage.size.width / trueImage.size.height
        return ratio
    }
    
    init(type: EmptyViewType) {
        self.type = type
        super.init(frame: .null)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements and Views
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .LabelColors.labelSecondary
        imageView.sizeToFit()
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelPrimary
        label.font = .placeholderTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    internal let reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle(Texts.EmptyView.retryButton, for: .normal)
        button.backgroundColor = .IconColors.backgroundPages
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .title()
        button.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpOutside)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Public Configure Method
    
    public func configurate() {
        setupContent()
        setupUI()
    }
    
    private func setupContent() {
        switch type {
        case .stats:
            title = Texts.EmptyView.statsTitle
            content = Texts.EmptyView.statsContent
            image = .EmptyView.stats
            reloadButton.isHidden = true
        case .favourite:
            title = Texts.EmptyView.favouriteTitle
            content = Texts.EmptyView.favouriteContent
            image = .EmptyView.favourites
            reloadButton.isHidden = true
        case .internet:
            title = Texts.EmptyView.noInternetTitle
            content = Texts.EmptyView.noInternetContent
            image = .EmptyView.internet
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(reloadButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 45),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            reloadButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 20),
            reloadButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            reloadButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 20),
        ])
    }

}


enum EmptyViewType {
    case stats
    case favourite
    case internet
}
