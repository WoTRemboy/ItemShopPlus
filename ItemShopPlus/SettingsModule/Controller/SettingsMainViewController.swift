//
//  SettingsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 28.04.2024.
//

import UIKit

class SettingsMainViewController: UIViewController {
    
    var settings: [[String]] = [
        [Texts.SettingsPage.aboutTitle],
        [Texts.SettingsPage.notificationsTitle, Texts.SettingsPage.appearanceTitle, Texts.SettingsPage.cacheTitle],
        [Texts.SettingsPage.languageTitle, Texts.SettingsPage.currencyTitle],
        [Texts.SettingsPage.emailTitle]
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
        case .notifications, .appearance, .language:
            print("Zmyak")
        case .cache:
            clearCache(indexPath: indexPath)
        case .currency:
            let vc = SettingsDetailsViewController(title: name, type: .currency)
            vc.completionHandler = { currencyCode in
                let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell
                cell?.detailTextLabel?.text = currencyCode
            }
            navigationController?.pushViewController(vc, animated: true)
        case .email:
            openMailApp()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAboutCollectionViewCell.identifier, for: indexPath) as? SettingsAboutCollectionViewCell else {
                fatalError("Failed to dequeue SettingsAboutCollectionViewCell in SettingsMainViewController")
            }
            cell.configurate()
            cell.isUserInteractionEnabled = false
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Failed to dequeue SettingsTableViewCell in SettingsMainViewController")
        }
        
        let name = settings[indexPath.section][indexPath.row]
        let type = SettingType.typeDefinition(name: name)
        
        switch type {
        case .notifications, .appearance, .language, .email:
            cell.setupCell(type: type)
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
            return Texts.SettingsPage.contactTitle
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
    
    private func openMailApp() {
        guard let emailURL = URL(string: "mailto:\(Texts.SettingsPage.emailContent)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL)
        } else {
            print("Mail app unavailable")
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
}