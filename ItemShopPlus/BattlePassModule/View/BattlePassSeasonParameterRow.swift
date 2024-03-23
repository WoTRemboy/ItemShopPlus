//
//  BattlePassSeasonParameterRow.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 03.03.2024.
//

import UIKit

final class BattlePassSeasonParameterRow: UIView {

    private let beginTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    private let beginContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.numberOfLines = 1
        return label
    }()
    
    private let endTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private let endContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    init(frame: CGRect, beginTitle: String, beginContent: String, endTitle: String, endContent: String) {
        beginTitleLable.text = beginTitle
        beginContentLabel.text = beginContent
        endTitleLable.text = endTitle
        endContentLabel.text = endContent
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configurate(content: String, _ end: String) {
        beginContentLabel.text = content
        endContentLabel.text = end
    }
    
    private func setupUI() {
        addSubview(separatorLine)
        addSubview(beginTitleLable)
        addSubview(beginContentLabel)
        addSubview(endTitleLable)
        addSubview(endContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        beginTitleLable.translatesAutoresizingMaskIntoConstraints = false
        beginContentLabel.translatesAutoresizingMaskIntoConstraints = false
        endTitleLable.translatesAutoresizingMaskIntoConstraints = false
        endContentLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            beginTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            beginTitleLable.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            beginTitleLable.trailingAnchor.constraint(equalTo: centerXAnchor),
            
            beginContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            beginContentLabel.leadingAnchor.constraint(equalTo: beginTitleLable.leadingAnchor),
            beginContentLabel.trailingAnchor.constraint(equalTo: beginTitleLable.trailingAnchor),
            
            endTitleLable.bottomAnchor.constraint(equalTo: beginTitleLable.bottomAnchor),
            endTitleLable.leadingAnchor.constraint(equalTo: beginTitleLable.trailingAnchor, constant: 5),
            endTitleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            
            endContentLabel.topAnchor.constraint(equalTo: beginContentLabel.topAnchor),
            endContentLabel.leadingAnchor.constraint(equalTo: endTitleLable.leadingAnchor),
            endContentLabel.trailingAnchor.constraint(equalTo: endTitleLable.trailingAnchor)
        ])
    }
}
