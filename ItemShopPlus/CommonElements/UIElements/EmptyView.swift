//
//  EmptyView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.01.2024.
//

import UIKit

/// A reusable view that displays a placeholder UI for empty or error states, with optional retry functionality
final class EmptyView: UIView {
    
    // MARK: - Properties & Initialization
    
    /// Enum representing the type of empty view (e.g., no stats, no internet, etc.)
    private let type: EmptyViewType
    
    /// Optional title text for the empty view, automatically updates the title label
    private var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
    
    /// Optional content text for the empty view, automatically updates the content label
    private var content: String? = nil {
        didSet {
            contentLabel.text = content
        }
    }
    
    /// Optional image for the empty view, automatically updates the image view
    private var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    /// Calculates the aspect ratio of the image to adjust the layout accordingly
    private var aspectRatio: CGFloat {
        guard let trueImage = image else { return 1 }
        let ratio = trueImage.size.width / trueImage.size.height
        return ratio
    }
    
    /// Initializes the `EmptyView` with a specific type
    /// - Parameter type: The type of empty view (e.g., .stats, .favourite, .internet)
    init(type: EmptyViewType) {
        self.type = type
        super.init(frame: .null)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements and Views
    
    /// The image view that displays an icon or graphic representing the empty state
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .LabelColors.labelSecondary
        imageView.sizeToFit()
        return imageView
    }()
    
    /// The label that displays the title for the empty state
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelPrimary
        label.font = .placeholderTitle()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// The label that displays the description or message related to the empty state
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    /// A button for retrying or reloading data, typically used in network-related empty states
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
    
    /// Animates the button when pressed down
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    /// Restores the button's scale when touch is lifted
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - Public Configure Method
    
    /// Configures the view based on the provided type and sets the content accordingly
    public func configurate() {
        setupContent()
        setupUI()
    }
    
    /// Sets up the content (title, description, and image) based on the type of empty view
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
    
    /// Sets up the UI elements (image, title, content, and button) and adds constraints
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

// MARK: - EmptyViewType

/// Enum representing different types of empty views that the `EmptyView` can display
enum EmptyViewType {
    case stats
    case favourite
    case internet
}
