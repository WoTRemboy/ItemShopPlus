//
//  QuestTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 15.12.2023.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    static let identifier = Texts.QuestCell.identifier

    private let questImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.noImage
        view.backgroundColor = .QuestsBundleColors.bundleBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let questTaskLabel: UILabel = {
        let text = UILabel()
        text.font = .body()
        text.text = Texts.QuestCell.questName
        text.textColor = .labelPrimary
        text.numberOfLines = 2
        return text
    }()
    
    private let questProgressLabel: UILabel = {
        let text = UILabel()
        text.font = .subhead()
        text.text = Texts.QuestCell.questProgress
        text.textColor = .labelTertiary
        text.numberOfLines = 1
        return text
    }()
    
    public func configurate(with name: String, _ progress: String, _ image: String?) {
        questTaskLabel.text = name
        questProgressLabel.text = Texts.QuestCell.requirement + progress
        
        if let imageUrlString = image {
            ImageLoader.loadAndShowImage(from: imageUrlString, to: questImageView)
        } else {
            questImageView.image = .Quests.experience
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        questImageView.image = .Quests.bundleBackground
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(questTaskLabel)
        contentView.addSubview(questProgressLabel)
        contentView.addSubview(questImageView)
                        
        bundleNameSetup()
        bundleTimeSetup()
        bundleImageViewSetup()
    }
    
    private func bundleNameSetup() {
        NSLayoutConstraint.activate([
            questTaskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            questTaskLabel.trailingAnchor.constraint(equalTo: questImageView.leadingAnchor, constant: -16),
            questTaskLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -13)
        ])
        questTaskLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bundleTimeSetup() {
        NSLayoutConstraint.activate([
            questProgressLabel.leadingAnchor.constraint(equalTo: questTaskLabel.leadingAnchor),
            questProgressLabel.trailingAnchor.constraint(equalTo: questTaskLabel.trailingAnchor),
            questProgressLabel.topAnchor.constraint(equalTo: questTaskLabel.bottomAnchor, constant: 8)
        ])
        questProgressLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bundleImageViewSetup() {
        NSLayoutConstraint.activate([
            questImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            questImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            questImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            questImageView.widthAnchor.constraint(equalTo: questImageView.heightAnchor)
        ])
        questImageView.translatesAutoresizingMaskIntoConstraints = false
    }
}
