//
//  CrewMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

class CrewMainViewController: UIViewController {
    
    private var items = [CrewItem]()
    private var itemPack = CrewPack(title: "", items: [CrewItem](), battlePassTitle: nil, addPassTitle: nil, image: nil, date: "", price: ["": ("", 0.0)])
    private var isPresentedFullScreen = false
    
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CrewCollectionViewCell.self, forCellWithReuseIdentifier: CrewCollectionViewCell.identifier)
        collectionView.register(ShopCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShopCollectionReusableView.identifier)
        collectionView.register(CrewFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CrewFooterReusableView.identifier)
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        guard items.isEmpty else { return }
        getItems(isRefreshControl: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        navigationBarSetup()
        collectionViewSetup()        
        noInternetSetup()
    }
    
    @objc private func refresh() {
        getItems(isRefreshControl: true)
    }
    
    private func getItems(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        self.networkService.getCrewItems { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            }
            
            switch result {
            case .success(let newPack):
                DispatchQueue.main.async {
                    self?.itemPack = newPack
                    self?.items = newPack.items
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = false
                    self?.noInternetView.isHidden = true
                }
                
            case .failure(let error):
                self?.collectionView.reloadData()
                self?.collectionView.isHidden = false
                self?.noInternetView.isHidden = false
                print(error)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.CrewPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func collectionViewSetup() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
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
        noInternetView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}


extension CrewMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CrewCollectionViewCell.identifier, for: indexPath) as? CrewCollectionViewCell else {
            fatalError("Failed to dequeue CrewCollectionViewCell in CrewMainViewController")
        }
        
        let item = items[indexPath.item]
        cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? "", image: item.image)
        
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            
            self.isPresentedFullScreen = true
            
            let item = self.items[indexPath.item]
            let image = item.image
            let name = item.name
            
            let vc = ShopGrantedPreviewViewController(image: image, name: name)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
}

extension CrewMainViewController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ShopCollectionReusableView.identifier, for: indexPath) as? ShopCollectionReusableView else {
                fatalError("Failed to dequeue ShopCollectionReusableView in ShopViewController")
            }
            headerView.configurate(with: Texts.CrewPageCell.header)
            return headerView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CrewFooterReusableView.identifier, for: indexPath) as? CrewFooterReusableView else {
                fatalError("Failed to dequeue ShopCollectionReusableView in ShopViewController")
            }
            footerView.configurate(price: itemPack.price?["USD"]?.1 ?? 0, symbol: itemPack.price?["USD"]?.0 ?? "", description: itemPack.items.first?.description ?? "", introduced: itemPack.items.first?.introduction ?? "", battlePass: itemPack.battlePassTitle ?? "", benefits: itemPack.addPassTitle ?? "")
            return footerView
        } else {
            fatalError("Unexpected kind value")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = CGFloat(16 + 70 * 4 + 150)
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
}
