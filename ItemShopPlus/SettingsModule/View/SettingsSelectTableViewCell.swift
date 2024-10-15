//
//  SettingsSelectTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

/// A custom table view cell used in the settings screen to display selectable options with an optional checkmark for selected items
final class SettingsSelectTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// The unique identifier for dequeuing the cell
    static let identifier = Texts.SettingsCell.selectIdentifier
    
    // MARK: - UI Elements and Views
    
    /// The label used for displaying the title of the setting option
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelPrimary
        label.font = .settings()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label used for displaying additional details for the setting option
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .labelSecondary
        label.font = .body()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Configurate Methods
    
    /// Configures the cell with a title, optional details, and a selection state
    /// - Parameters:
    ///   - title: The title of the setting option
    ///   - details: An optional string providing additional details about the setting
    ///   - selected: A Boolean indicating whether the option is currently selected (true for showing a checkmark)
    public func configure(title: String, details: String? = nil, selected: Bool = false) {
        self.accessoryType = selected ? .checkmark : .none
        titleLabel.text = title
        if let details {
            detailsLabel.text = details
        }
        setupUI()
    }
    
    /// Updates the cell's accessory type based on whether the option is checked
    /// - Parameter checked: A Boolean value indicating whether to display a checkmark
    public func selectUpdate(checked: Bool) {
        checked ? (accessoryType = .checkmark) : (accessoryType = .none)
    }
    
    // MARK: - UI Setup Method
    
    ///  Sets up the UI layout and constraints for the title and details labels
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
