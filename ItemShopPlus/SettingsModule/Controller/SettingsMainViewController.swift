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
        ["Notifications", "Theme", "Language", "Clear Cache"],
        ["Email"]
    ]
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsAboutCollectionViewCell.self, forCellReuseIdentifier: SettingsAboutCollectionViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backTable
        
        navigationBarSetup()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func navigationBarSetup() {
        title = Texts.SettingsPage.title
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
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
        if indexPath.section == 1, indexPath.row == 3 {
            clearCache()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsAboutCollectionViewCell.identifier, for: indexPath) as? SettingsAboutCollectionViewCell else {
                fatalError("Failed to dequeue SettingsAboutCollectionViewCell in SettingsMainViewController")
            }
            cell.configurate()
            cell.isUserInteractionEnabled = false
            return cell
            
        } else if indexPath.section == 1, indexPath.row == 3 {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = settings[indexPath.section][indexPath.row]
            cell.imageView?.image = UIImage(systemName: "trash.square.fill")
            cell.accessoryType = .none
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = settings[indexPath.section][indexPath.row]
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return Texts.SettingsPage.aboutTitle
        case 1:
            return "General"
        case 2:
            return "Contact"
        default:
            return nil
        }
    }
    
    private func clearCache() {
        let alertController = UIAlertController(title: nil, message: Texts.ClearCache.message, preferredStyle: .actionSheet)
        
        let cacheSize = ImageLoader.cacheSize() + VideoLoader.cacheSize()
        guard cacheSize != 0 else {
            alertControllerSetup(title: Texts.ClearCache.oops, message: Texts.ClearCache.alreadyClean)
            return
        }
            
        let clearAction = UIAlertAction(title: "\(Texts.ClearCache.cache) (\(String(format: "%.1f", cacheSize)) \(Texts.ClearCache.megabytes))", style: .destructive) { _ in
            VideoLoader.cleanCache(entire: true) {}
            ImageLoader.cleanCache(entire: true) {
                self.alertControllerSetup(title: Texts.ClearCache.success, message: Texts.ClearCache.cleared)
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
}
