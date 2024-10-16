//
//  ShopGrantedParanetersRowView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

/// A custom view that displays a title, content, and optionally an image with flexible text alignment
final class CollectionParametersRowView: UIView {
    
    // MARK: - UI Elements
    
    /// The image view to display a meaning-related icon
    private let meaningImageView = UIImageView()
    
    /// A label that displays the title of the row
    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label that displays the content or description under the title
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// A separator line to visually divide the row from others
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view with a frame, title, content, text alignment, and an optional image
    /// - Parameters:
    ///   - frame: The frame of the view
    ///   - title: The title text to be displayed
    ///   - content: The content or description text
    ///   - textAlignment: The alignment for the title and content text. Default is `.left`
    ///   - image: An optional image to display next to the title
    init(frame: CGRect, title: String, content: String, textAlignment: TextAlignment = .left, image: UIImage? = nil) {
        titleLable.text = title
        contentLabel.text = content
        super.init(frame: frame)
        
        selectAlignment(aligment: textAlignment)
        setupUI()
        
        if let image = image {
            setupMeaningImageView(image: image)
        } else {
            titleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor).isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurate Method
    
    /// Updates the content label with new content
    /// - Parameter content: The updated content string
    public func configurate(content: String) {
        contentLabel.text = content
    }
    
    // MARK: - Setup Methods
    
    /// Sets the alignment of the title and content labels
    /// - Parameter aligment: The alignment to apply to the labels (left, right, or center)
    private func selectAlignment(aligment: TextAlignment) {
        switch aligment {
        case .left:
            titleLable.textAlignment = .left
            contentLabel.textAlignment = .left
        case .right:
            titleLable.textAlignment = .right
            contentLabel.textAlignment = .right
        case .center:
            titleLable.textAlignment = .center
            contentLabel.textAlignment = .center
        }
    }
    
    /// Sets up the basic UI elements and their constraints
    private func setupUI() {
        addSubview(separatorLine)
        addSubview(titleLable)
        addSubview(contentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            titleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            titleLable.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            contentLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor)
        ])
    }
    
    /// Adds an image next to the title label and sets up its constraints
    /// - Parameter image: The image to display next to the title
    private func setupMeaningImageView(image: UIImage) {
        meaningImageView.image = image
        
        addSubview(meaningImageView)
        meaningImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            meaningImageView.topAnchor.constraint(equalTo: titleLable.topAnchor),
            meaningImageView.leadingAnchor.constraint(equalTo: titleLable.trailingAnchor),
            meaningImageView.heightAnchor.constraint(equalToConstant: 20),
            meaningImageView.widthAnchor.constraint(equalTo: meaningImageView.heightAnchor)
        ])
    }
}

// MARK: - TextAlignment

/// An enum representing the possible text alignments
enum TextAlignment {
    case left
    case right
    case center
}
