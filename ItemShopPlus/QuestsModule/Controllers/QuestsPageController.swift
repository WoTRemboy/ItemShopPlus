//
//  QuestsPageController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 15.12.2023.
//

import UIKit

class QuestsPageController: UIViewController {
    
    private let items: [Quest]
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(QuestTableViewCell.self, forCellReuseIdentifier: QuestTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    init(items: [Quest], title: String) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.title = title
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewSetup() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
}



extension QuestsPageController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: QuestTableViewCell.identifier, for: indexPath) as! QuestTableViewCell
        cell.contentView.heightAnchor.constraint(equalToConstant: (100 / 812 * view.frame.height)).isActive = true // constraints problem
        cell.questTaskLabel.text = items[indexPath.row].name
        
        cell.questProgressLabel.text = "Requirement: " + items[indexPath.row].progress
        
        if let imageUrlString = items[indexPath.row].image {
            ImageLoader.loadAndShowImage(from: imageUrlString, to: cell.questImageView)
        } else {
            cell.questImageView.image = .Quests.experience
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navVC = UINavigationController(rootViewController: QuestsDetailsViewController(item: items[indexPath.row]))
        present(navVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
