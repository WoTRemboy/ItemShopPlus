//
//  ShopGrantedViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.01.2024.
//

import UIKit

class ShopGrantedViewController: UIViewController {
    
    private var items = [GrantedItem?]()
    private let bundle: ShopItem
    private var original: [NSAttributedString.Key : Any]?
        
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ShopGrantedCollectionViewCell.self, forCellWithReuseIdentifier: ShopGrantedCollectionViewCell.identifier)
        collectionView.register(ShopGrantedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ShopGrantedCollectionReusableView.identifier)
        return collectionView
    }()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToShop
        return button
    }()
    
    init(bundle: ShopItem) {
        self.bundle = bundle
        self.items = bundle.granted
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = bundle.name
        view.backgroundColor = .BackColors.backDefault
        
        navigationItem.largeTitleDisplayMode = .always
        original = navigationController?.navigationBar.largeTitleTextAttributes
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        view.addSubview(collectionView)

        setupUI()
    }
    
    private func setupUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.largeTitleTextAttributes = original
    }
    
    private func countRows() -> Int {
        var count = 2 // first + last dates
        if !bundle.description.isEmpty { count += 1 }
        if bundle.series != nil { count += 1 }
        
        return count
    }
}

extension ShopGrantedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopGrantedCollectionViewCell.identifier, for: indexPath) as? ShopGrantedCollectionViewCell else {
            fatalError("Failed to dequeue ShopGrantedCollectionViewCell in ShopGrantedViewController")
        }
        if let item = items[indexPath.item] {
            cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? "", image: item.image)
        }
        
        return cell
    }
}

extension ShopGrantedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width / 2 - 25
        let heightSize = widthSize + (5 + 17 + 5 + 17 + 5) /* topAnchors + fontSizes */
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
        let height: CGFloat = CGFloat(16 + 70 * countRows() + 150)
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShopGrantedCollectionReusableView.identifier, for: indexPath) as? ShopGrantedCollectionReusableView else {
            fatalError("Failed to dequeue ShopCollectionReusableView in ShopViewController")
        }
        
        footerView.configurate(description: bundle.description, firstDate: bundle.firstReleaseDate ?? .now, lastDate: bundle.previousReleaseDate ?? .now, series: bundle.series, price: bundle.price)
        return footerView
    }
}
