//
//  LootDetailsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import UIKit

final class LootDetailsMainViewController: UIViewController {
    
    private var items = [LootDetailsItem]()
    private var groupedItems = [Dictionary<String, [LootDetailsItem]>.Element]()
    
    private let networkService = DefaultNetworkService()
    
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.register(LootDetailsMainCollectionViewCell.self, forCellWithReuseIdentifier: LootDetailsMainCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
        getItems(isRefreshControl: false)
    }
    
    @objc private func refreshWithControl() {
        getItems(isRefreshControl: true)
    }
    
    @objc private func refreshWithoutControl() {
        getItems(isRefreshControl: false)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    private func groupLootItems(items: [LootDetailsItem]) -> [Dictionary<String, [LootDetailsItem]>.Element] {
        var groupedItems = [String: [LootDetailsItem]]()
        let clearItems = uniqueItems(items: items)
        
        for item in clearItems {
            if groupedItems[item.name] == nil {
                groupedItems[item.name] = [item]
            } else {
                groupedItems[item.name]?.append(item)
            }
        }
        
        return groupedItems.sorted(by: { $0.key < $1.key })
    }
    
    private func uniqueItems(items: [LootDetailsItem]) -> [LootDetailsItem] {
        var uniqueItems = [String: LootDetailsItem]()

        for item in items {
            let key = "\(item.name)|\(item.rarity)"
            if uniqueItems[key] == nil {
                uniqueItems[key] = item
            }
        }

        return Array(uniqueItems.values)
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let items = self.groupedItems[indexPath.item].value
            self.navigationController?.pushViewController(LootDetailsRarityViewController(items: items), animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func getItems(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        noInternetView.isHidden = true
        
        self.networkService.getLootDetails { [weak self] result in
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
                    self?.items = newItems
                    self?.groupedItems = self?.groupLootItems(items: newItems) ?? []
                    
                    guard let collectionView = self?.collectionView else { return }
                    collectionView.isHidden = false
                    if isRefreshControl {
                        collectionView.reloadData()
                    } else {
                        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            collectionView.reloadData()
                        }, completion: nil)
                    }
                    self?.noInternetView.isHidden = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                }
                print(error)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.LootDetailsMain.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func noInternetSetup() {
        view.addSubview(noInternetView)
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        noInternetView.isHidden = true
        noInternetView.configurate()
        noInternetView.reloadButton.addTarget(self, action: #selector(refreshWithoutControl), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
}


// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension LootDetailsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LootDetailsMainCollectionViewCell.identifier, for: indexPath) as? LootDetailsMainCollectionViewCell else {
            fatalError("Failed to dequeue LootDetailsMainCollectionViewCell in LootDetailsMainViewController")
        }
        let groupedItem = groupedItems[indexPath.item]
        let item = groupedItem.value.first ?? LootDetailsItem.emptyLootDetails
        cell.configurate(type: .weapon, name: item.name, image: item.mainImage, firstStat: Double(groupedItem.value.count), secondStat: Double(item.stats.availableStats))
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LootDetailsMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 32
        let legacyWidth = (view.frame.width / 3)
        let heightSize = legacyWidth + 5 + 17 + 5 + 17 + 5 /* topAnchors + fontSizes */
        return CGSize(width: widthSize, height: heightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
            fatalError("Failed to dequeue CollectionHeaderReusableView in LootDetailsMainViewController")
        }
        headerView.configurate(with: Texts.LootDetailsMain.header)
        return headerView
    }
}
