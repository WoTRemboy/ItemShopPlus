//
//  SettingsTableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit
import FirebaseMessaging

class SettingsTableViewCell: UITableViewCell {
    
    static let identifier = Texts.SettingsCell.identifier
    
    internal let switchControl = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func updateDetails(detail: String) {
        detailTextLabel?.text = detail
    }
    
    public func setupCell(type: SettingType, details: String? = nil) {
        switch type {
        case .notifications:
            textLabel?.text = Texts.SettingsPage.notificationsTitle
            imageView?.image = .Settings.notifications
            switchSetup()
            accessoryType = .none
        case .appearance:
            textLabel?.text = Texts.SettingsPage.appearanceTitle
            imageView?.image = .Settings.appearance
            accessoryType = .disclosureIndicator
            detailTextLabel?.text = Texts.AppearanceSettings.system
        case .cache:
            textLabel?.text = Texts.SettingsPage.cacheTitle
            imageView?.image = .Settings.cache
            accessoryType = .none
        case .language:
            textLabel?.text = Texts.SettingsPage.languageTitle
            imageView?.image = .Settings.language
            accessoryType = .disclosureIndicator
            detailTextLabel?.text = Texts.SettingsPage.languageContent
        case .currency:
            textLabel?.text = Texts.SettingsPage.currencyTitle
            imageView?.image = .Settings.currency
            accessoryType = .disclosureIndicator
        case .developer:
            textLabel?.text = Texts.SettingsPage.developerTitle
            imageView?.image = .Settings.developer
            accessoryType = .disclosureIndicator
            detailTextLabel?.text = Texts.SettingsPage.developerContent
        case .designer:
            textLabel?.text = Texts.SettingsPage.designerTitle
            imageView?.image = .Settings.designer
            accessoryType = .disclosureIndicator
            detailTextLabel?.text = Texts.SettingsPage.designerContent
        case .email:
            textLabel?.text = Texts.SettingsPage.emailTitle
            imageView?.image = .Settings.email
            accessoryType = .disclosureIndicator
            detailTextLabel?.text = Texts.SettingsPage.emailContent
        }
        if let details {
            detailTextLabel?.text = details
        }
        setupUI()
    }
    
    private func switchSetup() {
        addSubview(switchControl)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        SettingsMainViewController.checkNotificationAuthorizationAndUpdateSwitch(switchControl: switchControl)
        
        NSLayoutConstraint.activate([
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupUI() {
        guard let imageView else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        guard let textLabel else { return }
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorInset = UIEdgeInsets(top: 0, left: 63, bottom: 0, right: 0)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16)
        ])
    }
    
}
