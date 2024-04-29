//
//  SettingsSelectTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

class SettingsSelectTableViewCell: UITableViewCell {
    
    static let identifier = Texts.SettingsCell.selectIdentifier
    
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
        textLabel?.text = title
        if let details {
            detailsLabel.text = details
        }
        setupUI()
    }
    
    public func selectUpdate() {
        accessoryType = .checkmark
    }
    
    private func setupUI() {
        addSubview(detailsLabel)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let textLabel else { return }
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: detailsLabel.leadingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            detailsLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 70),
            detailsLabel.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor)
        ])
    }
    
}
