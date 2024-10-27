//
//  QuestDetails.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 16.12.2023.
//

import UIKit

final class QuestDetailsView: UIView {
    
    let rewardImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage
        imageView.image = image
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let rewardLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Placeholder.noText
        label.font = .headline()
        label.textColor = .labelPrimary
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Placeholder.noText
        label.font = .body()
        label.textColor = .labelPrimary
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requirementLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.Placeholder.noText
        label.font = .body()
        label.textColor = .labelTertiary
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(rewardImageView)
        addSubview(rewardLabel)
        addSubview(taskLabel)
        addSubview(requirementLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            rewardImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            rewardImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            rewardImageView.widthAnchor.constraint(equalTo: rewardImageView.heightAnchor),
            
            rewardLabel.topAnchor.constraint(equalTo: rewardImageView.bottomAnchor, constant: 16),
            rewardLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            rewardLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            taskLabel.topAnchor.constraint(equalTo: rewardLabel.bottomAnchor, constant: 16),
            taskLabel.leadingAnchor.constraint(equalTo: rewardLabel.leadingAnchor),
            taskLabel.trailingAnchor.constraint(equalTo: rewardLabel.trailingAnchor),
            
            requirementLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 16),
            requirementLabel.leadingAnchor.constraint(equalTo: rewardLabel.leadingAnchor),
            requirementLabel.trailingAnchor.constraint(equalTo:  rewardLabel.trailingAnchor),
            requirementLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16),
        ])
    }

}
