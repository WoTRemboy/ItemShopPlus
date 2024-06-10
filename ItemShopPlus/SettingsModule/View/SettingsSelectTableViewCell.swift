//
//  SettingsSelectTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

class SettingsSelectTableViewCell: UITableViewCell {
    
    static let identifier = Texts.SettingsCell.selectIdentifier
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelPrimary
        label.font = .settings()
        label.numberOfLines = 1
        return label
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelSecondary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(title: String, details: String? = nil, selected: Bool = false) {
        self.accessoryType = selected ? .checkmark : .none
        titleLabel.text = title
        if let details {
            detailsLabel.text = details
        }
        setupUI()
    }
    
    public func selectUpdate(checked: Bool) {
        checked ? (accessoryType = .checkmark) : (accessoryType = .none)
        
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(detailsLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: detailsLabel.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            detailsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 70),
            detailsLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
    
}
