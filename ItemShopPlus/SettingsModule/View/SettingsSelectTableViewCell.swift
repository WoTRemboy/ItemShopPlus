//
//  SettingsSelectTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

class SettingsSelectTableViewCell: UITableViewCell {
    
    static let identifier = Texts.SettingsCell.selectIdentifier
    
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
            detailTextLabel?.text = details
        }
    }
    
    public func selectUpdate() {
        accessoryType = .checkmark
    }
    
}
