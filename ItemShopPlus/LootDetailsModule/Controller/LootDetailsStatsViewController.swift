//
//  LootDetailsStatsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 28.04.2024.
//

import UIKit

class LootDetailsStatsViewController: UIViewController {
    
    private var item = LootDetailsItem.emptyLootDetails
    private let fromRarity: Bool
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(LootDetailsRarityCollectionViewCell.self, forCellWithReuseIdentifier: LootDetailsRarityCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        collectionView.register(LootDetailsReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LootDetailsReusableView.identifier)
        return collectionView
    }()
    
    init(item: LootDetailsItem, fromRarity: Bool) {
        self.item = item
        self.fromRarity = fromRarity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        collectionViewSetup()
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let vc = ShopGrantedPreviewViewController(image: self.item.rarityImage, name: self.item.name)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.LootDetailsStats.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let buttonTitle: String
        if fromRarity {
            buttonTitle = Texts.LootDetailsStats.backRarities
        } else {
            buttonTitle = Texts.LootDetailsStats.backLoot
        }
        backButton.title = buttonTitle
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

extension LootDetailsStatsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LootDetailsRarityCollectionViewCell.identifier, for: indexPath) as? LootDetailsRarityCollectionViewCell else {
            fatalError("Failed to dequeue LootDetailsRarityCollectionViewCell in LootDetailsStatsViewController")
        }
        cell.configurate(name: item.name, type: Rarity.rarityToString(rarity: item.rarity), rarity: item.rarity, image: item.rarityImage, video: false)
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LootDetailsStatsViewController: UICollectionViewDelegateFlowLayout {
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
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
                fatalError("Failed to dequeue CollectionHeaderReusableView in LootDetailsStatsViewController")
            }
            headerView.configurate(with: item.name)
            return headerView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LootDetailsReusableView.identifier, for: indexPath) as? LootDetailsReusableView else {
                fatalError("Failed to dequeue LootDetailsReusableView in LootDetailsStatsViewController")
            }
            footerView.configurate(item: item.stats, description: item.description)
            return footerView
        } else {
            fatalError("Unexpected kind value")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let textWidth = view.frame.width - 32
        let textHeight = heightForText(item.description, width: textWidth, font: .subhead() ?? .systemFont(ofSize: 15)) + (!item.description.isEmpty ? 55 : 0)
        
        let height: CGFloat = CGFloat(16 + Int(textHeight) + 70 * item.stats.availableStats)
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
    
    private func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingRect = NSString(string: text).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil)
        return ceil(boundingRect.height)
    }
}
