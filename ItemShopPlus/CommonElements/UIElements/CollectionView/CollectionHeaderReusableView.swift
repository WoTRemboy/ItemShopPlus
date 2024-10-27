//
//  ShopCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.01.2024.
//

import UIKit

/// A reusable view for displaying a section header in a collection view
final class CollectionHeaderReusableView: UICollectionReusableView {
        
    // MARK: - Properties
    
    /// The reuse identifier for the collection view header
    static let identifier = Texts.CommonElements.headerIdentifier
    
    // MARK: - UI Elements
    
    /// A label displaying the section title
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .segmentTitle()
        label.textColor = .labelPrimary
        label.text = Texts.ShopPage.segmentName
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - Configurate & Setup Methods
    
    /// Configures the header view with the given title
    /// - Parameter title: The title to be displayed in the header
    public func configurate(with title: String) {
        sectionLabel.text = title
        setupUI()
    }
    
    /// Sets up the layout and constraints of the UI elements
    private func setupUI() {
        addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sectionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            sectionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sectionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
