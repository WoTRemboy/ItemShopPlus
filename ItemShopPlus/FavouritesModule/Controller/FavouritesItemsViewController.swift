//
//  FavouritesItemsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//

import UIKit

final class FavouritesItemsViewController: UIViewController {
    
    private var items = [ShopItem]()
    private let coreDataBase = FavouritesDataBaseManager.shared
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let emptyView = EmptyView(type: .favourite)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: ShopCollectionViewCell.identifier)
        collectionView.register(FavouritesFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FavouritesFooterReusableView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        coreDataBase.loadFromDataBase()
        items = coreDataBase.items.sorted { $0.name < $1.name }
        
        navigationBarSetup()
        collectionViewSetup()
        emptyView.configurate()
        setupUI()
    }
    
    @objc private func favouriteButtonPress(_ sender: UIButton) {
        guard let cell = sender.superview as? ShopCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell)
        else { return }
        
        favouriteItemToggle(at: indexPath)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let item = items[indexPath.item]
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            self.navigationController?.pushViewController(ShopGrantedViewController(bundle: item), animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func favouriteItemToggle(at indexPath: IndexPath) {
        let item = items[indexPath.item]
        items[indexPath.item].favouriteToggle()
        items.remove(at: indexPath.item)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [indexPath])
            }, completion: nil)
        })
        
        if self.items.isEmpty {
            UIView.animate(withDuration: 0.2) {
                self.collectionView.alpha = 0
                self.emptyView.alpha = 1
            }
        }
        
        let totalSum = self.items.reduce(0) { $0 + $1.price }
        self.footerUpdate(to: totalSum)
        
        DispatchQueue.global(qos: .utility).async {
            self.coreDataBase.removeFromDataBase(at: item.id)
        }
    }
    
    private func footerUpdate(to price: Int) {
        let visibleSections = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter)
        for indexPath in visibleSections {
            if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? FavouritesFooterReusableView {
                footerView.changePrice(to: price)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.FavouritesPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if !items.isEmpty {
            collectionView.isHidden = false
            emptyView.alpha = 0
        }
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyView.heightAnchor.constraint(equalToConstant: 115)
        ])
    }
    
}


// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension FavouritesItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.identifier, for: indexPath) as? ShopCollectionViewCell else {
            fatalError("Failed to dequeue ShopCollectionViewCell in FavouritesItemsViewController")
        }
        let width = view.frame.width / 2 - 25
        
        let item = items[indexPath.item]
        cell.configurate(with: item.images, item.name, item.price, item.regularPrice, item.banner, item.video, favourite: item.isFavourite, grantedCount: item.granted.filter({ $0?.name != "" }).count, width)
        
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPress), for: .touchUpInside)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavouritesItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width / 2 - 25
        let heightSize = widthSize + (5 + 17 + 5 + 17 + 5) /* topAnchor + fontSize */
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = 100
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavouritesFooterReusableView.identifier, for: indexPath) as? FavouritesFooterReusableView else {
            fatalError("Failed to dequeue FavouritesFooterReusableView in FavouritesItemsViewController")
        }
        let totalSum = items.reduce(0) { $0 + $1.price }
        footerView.configurate(price: totalSum)
        
        return footerView
    }
}
