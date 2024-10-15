//
//  SettingsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

/// A view controller for displaying and managing detailed settings such as appearance themes and currency options
final class SettingsDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Data source for currency options
    private var currencyData = [CurrencyModel]()
    /// Data source for appearance theme options
    private var themeData = [AppTheme]()
    /// The type of setting being displayed (e.g., appearance, currency)
    private var type: SettingType
    
    /// The currently selected option's title (e.g., currency code or theme key)
    private var selectedTitle = String()
    /// Index path of the previously selected cell
    private var previousIndex = IndexPath()
    /// A closure used to pass the selected value back to the calling view controller
    public var completionHandler: ((String) -> Void)?
    
    // MARK: - UI Elements
    
    /// The back button for navigation
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToSettings
        return button
    }()
    
    /// The table view for displaying the list of options
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsSelectTableViewCell.self, forCellReuseIdentifier: SettingsSelectTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    // MARK: - Initializers
    
    /// Initializes the view controller with the given title and setting type
    /// - Parameters:
    ///   - title: The title of the settings section (e.g., "Currency", "Appearance")
    ///   - type: The type of setting being managed (appearance or currency)
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
    
    // MARK: - Lifecycle Methods
    
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
        // Sends the selected value back via the completion handler when the view disappears
        if type == .appearance {
            completionHandler?(AppTheme.keyToValue(key: selectedTitle))
        } else {
            completionHandler?(selectedTitle)
        }
    }
    
    // MARK: - Memory Management
    
    /// Manages the saving and retrieving of the selected currency option
    /// - Parameter request: Specifies whether to get, save, or delete the currency selection
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
    
    // MARK: - UI Setup
    
    /// Configures the navigation bar
    private func navigationBarSetup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    /// Sets up the table view layout and constraints
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

// MARK: - UITableViewDelegate & UITableViewDataSource

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
            previousCell?.selectUpdate(checked: false)
            selectedCell?.selectUpdate(checked: true)
            previousIndex = indexPath
            
            // Details content methods
            switch type {
            case .appearance:
                selectedTitle = themeData[indexPath.row].keyValue
                themeMemoryManager(request: .save)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.changeTheme(style: self.themeData[indexPath.row].style)
                }
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
        
        // Details content content
        switch type {
        case .currency:
            let item = currencyData[indexPath.row]
            cell.configure(title: item.code, details: item.name, selected: selectedTitle == item.code)
        case .appearance:
            let item = themeData[indexPath.row]
            cell.configure(title: item.name, selected: selectedTitle == item.keyValue)
        default:
            return cell
        }
        return cell
    }
}

// MARK: - Theme Management

extension SettingsDetailsViewController {
    
    /// Manages the saving and retrieving of the selected theme option
    /// - Parameter request: Specifies whether to get, save, or delete the theme selection
    private func themeMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.AppearanceSettings.key) {
                selectedTitle = retrievedString
            } else {
                selectedTitle = Texts.AppearanceSettings.systemValue
                print("There is no currency data in UserDefaults")
            }
            let row = themeData.firstIndex(where: { $0.keyValue == selectedTitle } )
            previousIndex = IndexPath(row: row ?? 0, section: 0)
            
        case .save:
            UserDefaults.standard.set(selectedTitle, forKey: Texts.AppearanceSettings.key)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.AppearanceSettings.key)
        }
    }
    
    /// Changes the app's appearance theme
    /// - Parameter style: The Interface Style to apply (light, dark, or system)
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
