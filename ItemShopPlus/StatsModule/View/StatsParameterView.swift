//
//  StatsParameterView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

final class StatsParameterView: UIView {
    
    private let firstTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let firstContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let secondTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let secondContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let thirdTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.title
        label.textColor = .LabelColors.labelPrimary
        label.font = .headline()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let thirdContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.content
        label.textColor = .LabelColors.labelSecondary
        label.font = .subhead()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private let separatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .LabelColors.labelDisable
        return line
    }()
    
    public func configurate(firstTitle: String, firstContent: String, secondTitle: String, secondContent: String, thirdTitle: String = String(), thirdContent: String = String(), separator: Bool = true) {
        firstTitleLable.text = firstTitle
        firstContentLabel.text = firstContent
        secondTitleLable.text = secondTitle
        secondContentLabel.text = secondContent
        thirdTitleLable.text = thirdTitle
        thirdContentLabel.text = thirdContent
        
        separatorLine.isHidden = !separator
        thirdTitle.isEmpty ? setupDoubleUI() : setupTripleUI()
    }
    
    private func setupDoubleUI() {
        addSubview(separatorLine)
        addSubview(firstTitleLable)
        addSubview(firstContentLabel)
        addSubview(secondTitleLable)
        addSubview(secondContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLable.translatesAutoresizingMaskIntoConstraints = false
        firstContentLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLable.translatesAutoresizingMaskIntoConstraints = false
        secondContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            firstTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            firstTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -(UIScreen.main.bounds.width / 6)),
            firstTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            firstContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            firstContentLabel.leadingAnchor.constraint(equalTo: firstTitleLable.leadingAnchor),
            firstContentLabel.trailingAnchor.constraint(equalTo: firstTitleLable.trailingAnchor),
            
            secondTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            secondTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor, constant: UIScreen.main.bounds.width / 6),
            secondTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            secondContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            secondContentLabel.centerXAnchor.constraint(equalTo: secondTitleLable.centerXAnchor),
            secondContentLabel.widthAnchor.constraint(equalTo: secondTitleLable.widthAnchor)
        ])
    }
    
    private func setupTripleUI() {
        addSubview(separatorLine)
        addSubview(firstTitleLable)
        addSubview(firstContentLabel)
        addSubview(secondTitleLable)
        addSubview(secondContentLabel)
        addSubview(thirdTitleLable)
        addSubview(thirdContentLabel)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLable.translatesAutoresizingMaskIntoConstraints = false
        firstContentLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLable.translatesAutoresizingMaskIntoConstraints = false
        secondContentLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdTitleLable.translatesAutoresizingMaskIntoConstraints = false
        thirdContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            firstTitleLable.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            firstTitleLable.leadingAnchor.constraint(equalTo: separatorLine.leadingAnchor, constant: 16),
            firstTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            firstContentLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            firstContentLabel.leadingAnchor.constraint(equalTo: firstTitleLable.leadingAnchor),
            firstContentLabel.trailingAnchor.constraint(equalTo: firstTitleLable.trailingAnchor),
            
            secondTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            secondTitleLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            secondContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            secondContentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondContentLabel.widthAnchor.constraint(equalTo: secondTitleLable.widthAnchor),
            
            thirdTitleLable.bottomAnchor.constraint(equalTo: firstTitleLable.bottomAnchor),
            thirdTitleLable.trailingAnchor.constraint(equalTo: separatorLine.trailingAnchor, constant: -16),
            thirdTitleLable.widthAnchor.constraint(equalToConstant: 100),
            
            thirdContentLabel.topAnchor.constraint(equalTo: firstContentLabel.topAnchor),
            thirdContentLabel.leadingAnchor.constraint(equalTo: thirdTitleLable.leadingAnchor),
            thirdContentLabel.trailingAnchor.constraint(equalTo: thirdTitleLable.trailingAnchor)
        ])
    }
}

