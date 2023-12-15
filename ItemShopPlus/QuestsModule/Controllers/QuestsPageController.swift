//
//  QuestsPageController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import UIKit

class QuestsPageController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let items: [QuestBundle]
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(BundleTableViewCell.self, forCellReuseIdentifier: "BundleCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quests"
                
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    init(items: [QuestBundle]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BundleTableViewCell.identifier, for: indexPath) as! BundleTableViewCell
        cell.contentView.heightAnchor.constraint(equalToConstant: (100 / 812 * view.frame.height)).isActive = true // constraints problem
        cell.bundleName.text = items[indexPath.row].name
        if let end = items[indexPath.row].endDate {
            cell.bundleTime.text = differenceBetweenDates(date1: .now, date2: end)
        }
        
        let imageUrlString = items[indexPath.row].image
        ImageLoader.loadImage(from: imageUrlString) { image in
            if let image = image {
                cell.bundleImageView.image = image
            }
        }
        return cell
    }
    
    
}
