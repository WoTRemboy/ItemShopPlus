//
//  SettingsAboutCollectionViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 28.04.2024.
//

import UIKit

/// A custom cell that displays information about the app, including its name, icon, and version
final class SettingsAboutCollectionViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    /// The unique identifier for the cell, used for dequeuing
    static let identifier = Texts.SettingsAboutCell.identifier

    // MARK: - UI Elements and Views
    
    /// The image view displaying the app's icon
    private let appImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Settings.app
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// The label displaying the app's name
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.SettingsAboutCell.name
        label.textColor = .labelPrimary
        label.font = .title()
        label.numberOfLines = 1
        return label
    }()
    
    /// The label displaying the app's version number
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.SettingsAboutCell.version
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the cell with the app version
    /// - Parameter appVersion: A string representing the current version of the app
    public func configurate(appVersion: String) {
        appVersionLabel.text = appVersion
        setupUI()
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI layout and constraints for the cell's components
    private func setupUI() {
        addSubview(appImageView)
        addSubview(appNameLabel)
        addSubview(appVersionLabel)
        
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            appImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            appImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            appImageView.widthAnchor.constraint(equalTo: appImageView.heightAnchor),
            
            appNameLabel.centerYAnchor.constraint(equalTo: appImageView.centerYAnchor, constant: -11),
            appNameLabel.leadingAnchor.constraint(equalTo: appImageView.trailingAnchor, constant: 10),
            appNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            appVersionLabel.centerYAnchor.constraint(equalTo: appImageView.centerYAnchor, constant: 13),
            appVersionLabel.leadingAnchor.constraint(equalTo: appNameLabel.leadingAnchor),
            appVersionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
