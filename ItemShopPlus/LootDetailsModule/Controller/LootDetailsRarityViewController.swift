//
//  LootDetailsRarityViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.04.2024.
//

import UIKit

/// A view controller that displays loot items sorted by their rarity
final class LootDetailsRarityViewController: UIViewController {
    
    // MARK: - Properties
    
    /// An array of loot items that will be displayed
    private var items = [LootDetailsItem]()
    /// An array of loot items sorted by their rarity
    private var sortedItems = [LootDetailsItem]()
    /// Defines the order in which loot items should be sorted based on their rarity
    private let sortOrder: [Rarity] = [.common, .uncommon, .rare, .epic, .legendary, .mythic]
    
    // MARK: - UI Elements & Views
    
    /// A back button to navigate back to the previous screen
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.LootDetailsRarity.back
        return button
    }()
    
    /// The collection view that displays loot items
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LootDetailsRarityCollectionViewCell.self, forCellWithReuseIdentifier: LootDetailsRarityCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        
        return collectionView
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view controller with a list of loot items
    /// - Parameter items: An array of loot items to be displayed
    init(items: [LootDetailsItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.sortedItems = sortLootItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        
        navigationBarSetup()
        collectionViewSetup()
    }
    
    // MARK: - Handling User Interactions
    
    /// Handles tap gesture events and navigates to the selected loot item's detail page
    /// - Parameter gestureRecognizer: The gesture recognizer detecting the tap
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Animates the selection of a cell and pushes the item details view controller onto the navigation stack
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let item = self.sortedItems[indexPath.item]
            self.navigationController?.pushViewController(LootDetailsStatsViewController(item: item, fromRarity: true), animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Sorting method
    
    /// Sorts the loot items by their rarity in the order specified by `sortOrder`
    /// - Returns: An array of loot items sorted by rarity
    private func sortLootItems() -> [LootDetailsItem] {
        return items.sorted { (item1, item2) -> Bool in
            guard let firstIndex = sortOrder.firstIndex(of: item1.rarity),
                  let secondIndex = sortOrder.firstIndex(of: item2.rarity) else {
                return false
            }
            return firstIndex < secondIndex
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the navigation bar with a title and back button
    private func navigationBarSetup() {
        title = Texts.LootDetailsRarity.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    /// Sets up the collection view with a data source and delegate, and adds it to the view
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension LootDetailsRarityViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LootDetailsRarityCollectionViewCell.identifier, for: indexPath) as? LootDetailsRarityCollectionViewCell else {
            fatalError("Failed to dequeue LootDetailsRarityCollectionViewCell in LootDetailsRarityViewController")
        }
        let item = sortedItems[indexPath.item]
        cell.configurate(name: item.name, type: Rarity.rarityToString(rarity: item.rarity), rarity: item.rarity, image: item.rarityImage, video: false)
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LootDetailsRarityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width / 2 - 25
        let heightSize = widthSize + (5 + 17 + 5) /* topAnchors + fontSizes */
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
            fatalError("Failed to dequeue CollectionHeaderReusableView in LootDetailsRarityViewController")
        }
        let item = sortedItems[indexPath.item]
        headerView.configurate(with: item.name)
        return headerView
    }
}
