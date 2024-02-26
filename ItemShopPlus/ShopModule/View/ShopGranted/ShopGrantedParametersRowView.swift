//
//  ShopGrantedParanetersRowView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

class ShopGrantedParametersRowView: UIView {

    private let titleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    init(frame: CGRect, title: String, content: String) {
        titleLable.text = title
        contentLabel.text = content
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(content: String) {
        contentLabel.text = content
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
            titleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            contentLabel.leadingAnchor.constraint(equalTo: titleLable.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLable.trailingAnchor)
        ])
    }
}
