//
//  SettingsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.04.2024.
//

import UIKit

class SettingsDetailsViewController: UIViewController {
    
    private var data = [CurrencyModel]()
    private var selectedTitle = Texts.Currency.Code.usd
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
        super.init(nibName: nil, bundle: nil)
        self.title = title
        self.data = CurrencyModel.currencies.filter({
            SelectingMethods.selectCurrency(type: $0.code) != UIImage()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backTable
        
        navigationBarSetup()
        currencyMemoryManager(request: .get)
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
                print("There is no currency data in UserDefaults")
            }
            let row = data.firstIndex(where: { $0.code == selectedTitle } )
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
        return data.count
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
            
            selectedTitle = data[indexPath.row].code
            previousIndex = indexPath
            currencyMemoryManager(request: .save)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSelectTableViewCell.identifier, for: indexPath) as? SettingsSelectTableViewCell else {
            fatalError("Failed to dequeue SettingsSelectTableViewCell in SettingsDetailsViewController")
        }
        
        let item = data[indexPath.row]
        cell.configure(title: "\(item.code), \(item.name)", selected: selectedTitle == item.code)
        return cell
    }
}
