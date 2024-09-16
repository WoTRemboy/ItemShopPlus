//
//  QuestTestViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.03.2024.
//

import UIKit

final class QuestTestViewController: UIViewController {
    
    private var questBundles = [QuestBundle]()
    
    private let networkService = DefaultNetworkService()
    
    private let noInternetView = EmptyView(type: .internet)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        guard questBundles.isEmpty else { return }
        getBundles(isRefreshControl: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        tableViewSetup()
    }
    
    private func getBundles(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        self.networkService.getQuestBundles { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            }
            
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    self?.questBundles = newItems
                    self?.tableView.beginUpdates()
                    
                    for row in 0..<(self?.questBundles.count ?? 1) {
                        self?.tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .fade) }
                    self?.tableView.endUpdates()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.Quest.title
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension QuestTestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questBundles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BundleTableViewCell.identifier, for: indexPath) as? BundleTableViewCell else {
            fatalError("Failed to dequeue BundleTableViewCell in QuestsBundlePageController")
        }
        
        let bundle = questBundles[indexPath.row]
        cell.configurate(with: bundle.name, bundle.image, Date.now)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = 100 / 812 * view.frame.height
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let subBundle = questBundles[indexPath.row].subBundles.first else { return }
        navigationController?.pushViewController(QuestsPageController(items: subBundle.quests, title: questBundles[indexPath.row].name), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
