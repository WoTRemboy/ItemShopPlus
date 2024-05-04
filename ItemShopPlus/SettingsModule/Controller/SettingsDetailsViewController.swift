//
//  SettingsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

class SettingsDetailsViewController: UIViewController {
    
    private var currencyData = [CurrencyModel]()
    private var themeData = [AppTheme]()
    private var type: SettingType
    
    private var selectedTitle = String()
    private var previousIndex = IndexPath()
    public var completionHandler: ((String) -> Void)?
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToSettings
        return button
    }()
        
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsSelectTableViewCell.self, forCellReuseIdentifier: SettingsSelectTableViewCell.identifier)
        return table
    }()
    
    init(title: String, type: SettingType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        self.title = title
        switch type {
        case .currency:
            self.currencyData = CurrencyModel.currencies.filter({
                SelectingMethods.selectCurrency(type: $0.code) != UIImage()
            })
        case .appearance:
            self.themeData = AppTheme.themes
        default:
            print("Default cell")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backTable
        
        navigationBarSetup()
        switch type {
        case .appearance:
            themeMemoryManager(request: .get)
        case .currency:
            currencyMemoryManager(request: .get)
        default:
            return
        }
        tableViewSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        completionHandler?(selectedTitle)
    }
    
    private func currencyMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
                selectedTitle = retrievedString
            } else {
                selectedTitle = Texts.Currency.Code.usd
                print("There is no currency data in UserDefaults")
            }
            let row = currencyData.firstIndex(where: { $0.code == selectedTitle } )
            previousIndex = IndexPath(row: row ?? 0, section: 0)
            
        case .save:
            UserDefaults.standard.set(selectedTitle, forKey: Texts.CrewPage.currencyKey)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.CrewPage.currencyKey)
        }
    }
    
    private func navigationBarSetup() {
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


extension SettingsDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .currency:
            return currencyData.count
        case .appearance:
            return themeData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(45)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath != previousIndex {
            let previousCell = tableView.cellForRow(at: previousIndex) as? SettingsSelectTableViewCell
            let selectedCell = tableView.cellForRow(at: indexPath) as? SettingsSelectTableViewCell
            previousCell?.accessoryType = .none
            selectedCell?.accessoryType = .checkmark
            previousIndex = indexPath
            
            switch type {
            case .appearance:
                selectedTitle = themeData[indexPath.row].name
                themeMemoryManager(request: .save)
                changeTheme(style: themeData[indexPath.row].style)
            case .currency:
                selectedTitle = currencyData[indexPath.row].code
                currencyMemoryManager(request: .save)
            default:
                return
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSelectTableViewCell.identifier, for: indexPath) as? SettingsSelectTableViewCell else {
            fatalError("Failed to dequeue SettingsSelectTableViewCell in SettingsDetailsViewController")
        }
        
        switch type {
        case .currency:
            let item = currencyData[indexPath.row]
            cell.configure(title: item.code, details: item.name, selected: selectedTitle == item.code)
        case .appearance:
            let item = themeData[indexPath.row]
            cell.configure(title: item.name, selected: selectedTitle == item.name)
        default:
            return cell
        }
        return cell
    }
}


extension SettingsDetailsViewController {
    
    private func themeMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.AppearanceSettings.key) {
                selectedTitle = retrievedString
            } else {
                selectedTitle = Texts.AppearanceSettings.system
                print("There is no currency data in UserDefaults")
            }
            let row = themeData.firstIndex(where: { $0.name == selectedTitle } )
            previousIndex = IndexPath(row: row ?? 0, section: 0)
            
        case .save:
            UserDefaults.standard.set(selectedTitle, forKey: Texts.AppearanceSettings.key)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.AppearanceSettings.key)
        }
    }
    
    private func changeTheme(style: UIUserInterfaceStyle) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = style
                })
            }
        }
    }
}
