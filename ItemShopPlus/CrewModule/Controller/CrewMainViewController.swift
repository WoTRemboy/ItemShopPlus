//
//  CrewMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

class CrewMainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var items = [CrewItem]()
    private var itemPack = CrewPack.emptyPack
    
    private var currentSectionTitle = Texts.Currency.Code.usd
    private var selectedSectionTitle = Texts.Currency.Code.usd
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .CurrencySymbol.usd
        button.isEnabled = false
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionRarityCell.self, forCellWithReuseIdentifier: CollectionRarityCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        collectionView.register(CrewFooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CrewFooterReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        guard items.isEmpty else { return }
        getItems(isRefreshControl: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault

        currencyMemoryManager(request: .get)
        selectedSectionTitle = currentSectionTitle
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
    }
    
    // MARK: - Actions
    
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
    
    // MARK: - Networking
    
    private func getItems(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        noInternetView.isHidden = true
        
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
                    self?.symbolButton.isEnabled = true
                    self?.menuSetup()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.symbolButton.isEnabled = false
                }
                print(error)
            }
        }
    }
    
    // MARK: - UserDefaults Currency
    
    private func currencyMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
                currentSectionTitle = retrievedString
            } else {
                print("There is no currency data in UserDefaults")
            }
        case .save:
            UserDefaults.standard.set(currentSectionTitle, forKey: Texts.CrewPage.currencyKey)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.CrewPage.currencyKey)
        }
    }
    
    // MARK: - Changing Currency Methods
    
    private func updateAll(price: CrewPrice) {
        guard selectedSectionTitle != price.code else { return }
        updateMenuState(for: price.code)
        currentSectionTitle = price.code
        currencyMemoryManager(request: .save)
        
        headerUpdate(price: price)
    }
    
    private func headerUpdate(price: CrewPrice) {
        let visibleSections = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter)
        for indexPath in visibleSections {
            if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? CrewFooterReusableView {
                footerView.changePrice(price: price, firstTime: false)
            }
        }
    }
    
    // MARK: - Cell Animation Method
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
                        
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
    
    // MARK: - UI Setups
    
    private func navigationBarSetup() {
        title = Texts.CrewPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
        symbolButton.image = SelectingMethods.selectCurrency(type: currentSectionTitle)
    }
    
    private func menuSetup() {
        let prices = itemPack.price.filter( {
            SelectingMethods.selectCurrency(type: $0.code) != UIImage()
        } )
        
        var children = [UIAction]()
        for price in prices.sorted(by: { $0.code < $1.code }) {
            let sectionAction = UIAction(title: price.code, image: SelectingMethods.selectCurrency(type: price.code)) { [weak self] action in
                if #available(iOS 17.0, *) {
                    self?.navigationItem.rightBarButtonItem?.setSymbolImage(SelectingMethods.selectCurrency(type: price.code), contentTransition: .replace)
                } else {
                    self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectCurrency(type: price.code)
                }
                self?.updateAll(price: price)
            }
            children.append(sectionAction)
            price.code == currentSectionTitle ? sectionAction.state = .on : nil
        }
        let curPrice = prices.first(where: { $0.code == currentSectionTitle }) ?? CrewPrice.emptyPrice
        symbolButton.menu = UIMenu(title: "", children: children)
        headerUpdate(price: curPrice)
    }

    private func updateMenuState(for sectionTitle: String) {
        guard selectedSectionTitle != sectionTitle else { return }
        if let currentAction = symbolButton.menu?.children.first(where: { $0.title == sectionTitle }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = symbolButton.menu?.children.first(where: { $0.title == selectedSectionTitle }) as? UIAction {
            previousAction.state = .off
        }
        selectedSectionTitle = sectionTitle
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

extension CrewMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionRarityCell.identifier, for: indexPath) as? CollectionRarityCell else {
            fatalError("Failed to dequeue CrewCollectionViewCell in CrewMainViewController")
        }
        let item = items[indexPath.item]
        cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? .common, image: item.image)
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
                fatalError("Failed to dequeue CollectionHeaderReusableView in CrewMainViewController")
            }
            headerView.configurate(with: Texts.CrewPageCell.header)
            return headerView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CrewFooterReusableView.identifier, for: indexPath) as? CrewFooterReusableView else {
                fatalError("Failed to dequeue CrewFooterReusableView in CrewMainViewController")
            }
            let price = itemPack.price.first(where: { $0.code == currentSectionTitle }) ?? CrewPrice(type: .usd, code: "", symbol: "", price: 0)
            footerView.configurate(
                price: price,
                description: itemPack.items.first?.description ?? Texts.CrewPageCell.itemName,
                introduced: itemPack.items.first?.introduction ?? Texts.CrewPageCell.introductionText,
                battlePass: itemPack.battlePassTitle ?? "–",
                benefits: itemPack.addPassTitle ?? Texts.CrewPageCell.no)
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
