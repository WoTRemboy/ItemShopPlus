//
//  LootDetailsRarityViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.04.2024.
//

import UIKit

class LootDetailsRarityViewController: UIViewController {
    
    private var items = [LootDetailsItem]()
    private var sortedItems = [LootDetailsItem]()
    private let sortOrder: [Rarity] = [.common, .uncommon, .rare, .epic, .legendary, .mythic]
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.LootDetailsRarity.back
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LootDetailsRarityCollectionViewCell.self, forCellWithReuseIdentifier: LootDetailsRarityCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    init(items: [LootDetailsItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
        self.sortedItems = sortLootItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        
        navigationBarSetup()
        collectionViewSetup()
    }
    
    private func sortLootItems() -> [LootDetailsItem] {
        return items.sorted { (item1, item2) -> Bool in
            guard let firstIndex = sortOrder.firstIndex(of: item1.rarity),
                  let secondIndex = sortOrder.firstIndex(of: item2.rarity) else {
                return false
            }
            return firstIndex < secondIndex
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.LootDetailsRarity.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
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
//        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
//        cell.addGestureRecognizer(pressGesture)
        
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
