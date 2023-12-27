//
//  QuestsPageController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import UIKit

class QuestsBundlePageController: UIViewController {
    
    private let networkService = DefaultNetworkService()
    private var items: [QuestBundle] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BundleTableViewCell.self, forCellReuseIdentifier: BundleTableViewCell.identifier)
        return table
    }()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.Pages.quests
        
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getBundles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getBundles() {
        self.networkService.getQuestBundles { [weak self] result in
            switch result {
            case .success(let newItems):
                guard self?.areBundlesEqual(from: self?.items ?? [], to: newItems) != true else { return }
                
                DispatchQueue.main.async {
                    self?.items = newItems
                    self?.tableView.beginUpdates()
                    
                    for row in 0..<(self?.items.count ?? 1) {
                        self?.tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .fade)
                    }
                    
                    self?.tableView.endUpdates()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func areBundlesEqual(from: [QuestBundle], to: [QuestBundle]) -> Bool {
        guard from.count == to.count else { return false }
        for row in 0..<from.count {
            guard from[row] == to[row] else { return false }
        }
        return true
    }
    
    private func tableViewSetup() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}



extension QuestsBundlePageController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BundleTableViewCell.identifier, for: indexPath) as! BundleTableViewCell
        cell.contentView.heightAnchor.constraint(equalToConstant: (100 / 812 * view.frame.height)).isActive = true // constraints problem
        cell.bundleNameLabel.text = items[indexPath.row].name
        if let end = items[indexPath.row].endDate {
            cell.bundleTimeLabel.text = DateFormating.differenceBetweenDates(date1: .now, date2: end)
        }
        
        ImageLoader.loadAndShowImage(from: items[indexPath.row].image, to: cell.bundleImageView)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(QuestsPageController(items: items[indexPath.row].quests, title: items[indexPath.row].name), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
