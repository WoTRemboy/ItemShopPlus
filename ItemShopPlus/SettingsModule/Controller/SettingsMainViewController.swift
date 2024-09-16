//
//  SettingsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 28.04.2024.
//

import UIKit

final class SettingsMainViewController: UIViewController {
    
    var settings: [[String]] = [
        [Texts.SettingsPage.aboutTitle],
        [Texts.SettingsPage.notificationsTitle, Texts.SettingsPage.appearanceTitle, Texts.SettingsPage.cacheTitle],
        [Texts.SettingsPage.languageTitle, Texts.SettingsPage.currencyTitle],
        [Texts.SettingsPage.developerTitle, Texts.SettingsPage.designerTitle, Texts.SettingsPage.emailTitle]
    ]
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsAboutCollectionViewCell.self, forCellReuseIdentifier: SettingsAboutCollectionViewCell.identifier)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backTable
        
        navigationBarSetup()
        tableViewSetup()
    }
    
    private func navigationBarSetup() {
        title = Texts.SettingsPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension SettingsMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(80)
        }
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = settings[indexPath.section][indexPath.row]
        let type = SettingType.typeDefinition(name: name)
        
        switch type {
        case .notifications:
            print("Zmyak")
        case .appearance:
            let vc = SettingsDetailsViewController(title: name, type: .appearance)
            vc.completionHandler = { currencyCode in
                let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell
                cell?.detailTextLabel?.text = currencyCode
            }
            navigationController?.pushViewController(vc, animated: true)
        case .language:
            didRequestAlert(type: .language)
        case .cache:
            clearCache(indexPath: indexPath)
        case .currency:
            let vc = SettingsDetailsViewController(title: name, type: .currency)
            vc.completionHandler = { currencyCode in
                let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell
                cell?.detailTextLabel?.text = currencyCode
            }
            navigationController?.pushViewController(vc, animated: true)
        case .email, .developer, .designer:
            openURL(type: type)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAboutCollectionViewCell.identifier, for: indexPath) as? SettingsAboutCollectionViewCell else {
                fatalError("Failed to dequeue SettingsAboutCollectionViewCell in SettingsMainViewController")
            }
            
            var appVersionString = String()
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
               let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                appVersionString = "\(appVersion) \(Texts.SettingsAboutCell.version) \(buildVersion)"
            }
            cell.configurate(appVersion: appVersionString)
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Failed to dequeue SettingsTableViewCell in SettingsMainViewController")
        }
        
        let name = settings[indexPath.section][indexPath.row]
        let type = SettingType.typeDefinition(name: name)
        
        switch type {
        case .language, .email, .developer, .designer:
            cell.setupCell(type: type)
        case .appearance:
            let text = getTheme()
            cell.setupCell(type: type, details: text)
        case .notifications:
            cell.setupCell(type: type)
            cell.selectionStyle = .none
            cell.switchControl.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        case .cache:
            let cacheSize = ImageLoader.cacheSize() + VideoLoader.cacheSize()
            let text = cacheSize != 0 ? "\(String(format: "%.1f", cacheSize)) \(Texts.ClearCache.megabytes)" : Texts.SettingsPage.emptyCacheContent
            cell.setupCell(type: type, details: text)
        case .currency:
            let text = getCurrency()
            cell.setupCell(type: type, details: text)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Texts.SettingsPage.aboutTitle
        case 1:
            return Texts.SettingsPage.generalTitle
        case 2:
            return Texts.SettingsPage.localizationTitle
        case 3:
            return Texts.SettingsPage.teamTitle
        default:
            return nil
        }
    }
    
    private func clearCache(indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: Texts.ClearCache.message, preferredStyle: .actionSheet)
        
        let cacheSize = ImageLoader.cacheSize() + VideoLoader.cacheSize()
        guard cacheSize != 0 else {
            alertControllerSetup(title: Texts.ClearCache.oops, message: Texts.ClearCache.alreadyClean)
            return
        }
        
        let clearAction = UIAlertAction(title: "\(Texts.ClearCache.cache)", style: .destructive) { _ in
            VideoLoader.cleanCache(entire: true) {}
            ImageLoader.cleanCache(entire: true) {
                self.alertControllerSetup(title: Texts.ClearCache.success, message: Texts.ClearCache.cleared)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: Texts.ClearCache.cancel, style: .cancel)
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func alertControllerSetup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    private func openURL(type: SettingType) {
        var url: URL? = nil
        switch type {
        case .developer:
            if let linkedInURL = URL(string: Texts.SettingsPage.developerLink) {
                url = linkedInURL
            }
        case .designer:
            if let telegramURL = URL(string: Texts.SettingsPage.designerLink) {
                url = telegramURL
            }
        case .email:
            if let emailURL = URL(string: "mailto:\(Texts.SettingsPage.emailContent)") {
                url = emailURL
            }
        default:
            return
        }
        
        guard let openUrl = url else { return }
        
        if UIApplication.shared.canOpenURL(openUrl) {
            UIApplication.shared.open(openUrl)
        } else {
            print("url is incorrect")
        }
    }
    
    private func getCurrency() -> String {
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
            return retrievedString
        } else {
            print("There is no currency data in UserDefaults")
            return Texts.Currency.Code.usd
        }
    }
    
    private func getTheme() -> String {
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.AppearanceSettings.key) {
            return AppTheme.keyToValue(key: retrievedString)
        } else {
            print("There is no currency data in UserDefaults")
            return Texts.AppearanceSettings.system
        }
    }
}


extension SettingsMainViewController {
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            enableNotifications(switchControl: sender)
        } else {
            disableAllNotifications(switchControl: sender)
        }
    }
    
    static func checkNotificationAuthorizationAndUpdateSwitch(switchControl: UISwitch) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional, .ephemeral:
                    if UIApplication.shared.isRegisteredForRemoteNotifications {
                        switchControl.isOn = true
                    } else {
                        switchControl.isOn = false
                    }
                case .denied, .notDetermined:
                    switchControl.isOn = false
                @unknown default:
                    switchControl.isOn = false
                }
            }
        }
    }
    
    private func disableAllNotifications(switchControl: UISwitch) {
        UIApplication.shared.unregisterForRemoteNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UserDefaults.standard.set(Texts.NotificationSettings.disable, forKey: Texts.NotificationSettings.key)
        switchControl.isOn = false
        print("Notifications disabled")
    }
    
    private func enableNotifications(switchControl: UISwitch) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                    UserDefaults.standard.set(Texts.NotificationSettings.enable, forKey: Texts.NotificationSettings.key)
                    switchControl.isOn = true
                    print("Notifications enabled")
                } else {
                    switchControl.isOn = false
                    self?.didRequestAlert(type: .notifications)
                    print("Notifications disabled")
                }
            }
        }
    }
    
    private func didRequestAlert(type: SettingType) {
        let title: String
        let message: String
        
        if type == .notifications {
            title = Texts.NotificationSettings.alertTitle
            message = Texts.NotificationSettings.alertContent
        } else {
            title = Texts.LanguageSettings.alertTitle
            message = Texts.LanguageSettings.alertContent
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Texts.NotificationSettings.alertSettings, style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }))
        alert.addAction(UIAlertAction(title: Texts.NotificationSettings.alertCancel, style: .cancel))
        present(alert, animated: true)
    }
}
