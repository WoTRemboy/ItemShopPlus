//
//  ShopGrantedParanetersRowView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

final class CollectionParametersRowView: UIView {
    
    private let meaningImageView = UIImageView()

    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
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
    
    public func configurate(content: String) {
        contentLabel.text = content
    }
    
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

enum TextAlignment {
    case left
    case right
    case center
}
