//
//  BundlesMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.04.2024.
//

import UIKit
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "BundlesModule", category: "MainController")

/// The view controller for displaying and managing bundle items in the shop
final class BundlesMainViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The list of bundle items
    private var items = [BundleItem]()
    /// The currently selected currency section
    private var currentSectionTitle = Texts.Currency.Code.usd
    /// The previously selected currency section
    private var selectedSectionTitle = Texts.Currency.Code.usd
    
    /// The network service responsible for fetching bundle data
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements
    
    /// A view displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// The activity indicator displayed when loading data
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    /// The refresh control for reloading the bundle list
    private let refreshControl = UIRefreshControl()
    
    /// The collection view for displaying the bundle items
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(BundlesCollectionViewCell.self, forCellWithReuseIdentifier: BundlesCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    /// A back button to navigate to the main screen
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// A button for selecting the currency symbol
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .CurrencySymbol.usd
        button.isEnabled = false
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        currencyMemoryManager(request: .get)
        selectedSectionTitle = currentSectionTitle
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
        getShop(isRefreshControl: false)
    }
    
    // MARK: - Actions
    
    /// Fetches the shop bundles either from a refresh control
    @objc private func refreshWithControl() {
        getShop(isRefreshControl: true)
    }
    
    /// Fetches the shop bundles without using a refresh control
    @objc private func refreshWithoutControl() {
        getShop(isRefreshControl: false)
    }
    
    /// Handles tap gestures on the collection view cells, animating the cell and presenting its details
    /// - Parameter gestureRecognizer: The tap gesture recognizer object
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Retrieves shop data from the network and updates the UI accordingly
    /// - Parameter isRefreshControl: Indicates whether to show the refresh control indicator
    private func getShop(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        noInternetView.isHidden = true
        
        self.networkService.getBundles { [weak self] result in
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
                    self?.noInternetView.isHidden = true
                    self?.symbolButton.isEnabled = true
                    self?.menuSetup()
                    
                    guard let collectionView = self?.collectionView else { return }
                    collectionView.isHidden = false
                    if isRefreshControl {
                        collectionView.reloadData()
                    } else {
                        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            collectionView.reloadData()
                        }, completion: nil)
                    }
                }
                logger.info("Bundles items loaded successfully")
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.items.removeAll()
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.symbolButton.isEnabled = false
                }
                logger.error("Bundles items loading error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Currency Management
    
    /// Manages saving, retrieving, or deleting the selected currency from `UserDefaults`
    /// - Parameter request: The type of action to perform (get, save, delete)
    private func currencyMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
                currentSectionTitle = retrievedString
                logger.info("Currency data retrieved from UserDefaults: \(retrievedString)")
            } else {
                logger.info("There is no currency data in UserDefaults")
            }
        case .save:
            UserDefaults.standard.set(currentSectionTitle, forKey: Texts.CrewPage.currencyKey)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.CrewPage.currencyKey)
        }
    }
        
    /// Updates the bundle prices with the selected currency and reloads the data
    /// - Parameters:
    ///   - price: The new `BundlePrice` to apply
    ///   - animated: A boolean to determine if the change should be animated
    private func updateAll(price: BundlePrice, animated: Bool = true) {
        guard selectedSectionTitle != price.code else { return }
        updateMenuState(for: price.code)
        currentSectionTitle = price.code
        currencyMemoryManager(request: .save)
        priceLabelUpdate(type: price.type, reload: true, animated: animated)
    }
    
    /// Updates the price labels in all visible cells based on the selected currency
    /// - Parameters:
    ///   - type: The `Currency` to apply to the prices
    ///   - reload: Whether the collection view should be reloaded
    ///   - animated: A boolean to determine if the update should be animated
    private func priceLabelUpdate(type: Currency, reload: Bool, animated: Bool = true) {
        for i in 0..<items.count {
            items[i].currency = type
        }
        guard reload else { return }
        
        let cellsCount = collectionView.numberOfItems(inSection: 0)

        for i in 0..<cellsCount {
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? BundlesCollectionViewCell {
                let item = items[indexPath.item]
                if let price = item.prices.first(where: { $0.type == item.currency }) {
                    cell.priceUpdate(price: priceDefinition(price: price), animated: animated)
                }
            }
        }
    }
    
    /// Converts the `BundlePrice` to a formatted string based on the currency's symbol position
    /// - Parameter price: The `BundlePrice` to format
    /// - Returns: A formatted string of the price
    private func priceDefinition(price: BundlePrice) -> String {
        let symbolPosition = SelectingMethods.selectCurrencyPosition(type: price.type)
        guard price.price != 0.0 else { return Texts.BundleCell.free }
        let priceToShow = Int(price.price * 10) % 10 == 0 ? String(Int(price.price.rounded())) : String(price.price)
        
        switch symbolPosition {
        case .left:
            return "\(price.symbol) \(priceToShow)"
        case .right:
            return "\(priceToShow) \(price.symbol)"
        }
    }
    
    // MARK: - Cell Animation
    
    /// Animates the selection of a bundle cell and presents the details view for the selected bundle
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        let item = items[indexPath.item]
        let vc = BundlesDetailsViewController(item: item, fromMainPage: false)
        vc.completionHandler = { [weak self] newBundlePrice in
            self?.updateAll(price: newBundlePrice, animated: false)
            self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectCurrency(type: newBundlePrice.code)
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            self.navigationController?.pushViewController(vc, animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Menu Setup
    
    /// Sets up the currency menu for switching between different currencies
    private func menuSetup() {
        guard let prices = items.first?.prices.filter( {
            SelectingMethods.selectCurrency(type: $0.code) != UIImage()
        } ) else { return }
        
        var children = [UIAction]()
        for price in prices.sorted(by: { $0.code < $1.code }) {
            let sectionAction = UIAction(title: price.code, image: SelectingMethods.selectCurrency(type: price.code)) { [weak self] action in
                self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectCurrency(type: price.code)
                self?.updateAll(price: price)
            }
            children.append(sectionAction)
            price.code == currentSectionTitle ? sectionAction.state = .on : nil
        }
        let curPrice = prices.first(where: { $0.code == currentSectionTitle }) ?? BundlePrice.emptyPrice
        symbolButton.menu = UIMenu(title: "", children: children)
        priceLabelUpdate(type: curPrice.type, reload: false)
    }
    
    /// Updates the menu state to reflect the currently selected currency
    /// - Parameter sectionTitle: The title of the currently selected section
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
    
    // MARK: - UI Setup
    
    /// Configures the navigation bar for the view
    private func navigationBarSetup() {
        title = Texts.BundlesPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
        symbolButton.image = SelectingMethods.selectCurrency(type: currentSectionTitle)
    }
    
    /// Configures the collection view, its delegate, and its layout
    private func collectionViewSetup() {
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    /// Configures the no-internet view for cases when the network is unavailable
    private func noInternetSetup() {
        view.addSubview(noInternetView)
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        noInternetView.isHidden = true
        noInternetView.configurate()
        noInternetView.reloadButton.addTarget(self, action: #selector(refreshWithoutControl), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension BundlesMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BundlesCollectionViewCell.identifier, for: indexPath) as? BundlesCollectionViewCell else {
            fatalError("Failed to dequeue BundleCollectionViewCell in BundleMainViewController")
        }
        
        let item = items[indexPath.item]
        if let price = item.prices.first(where: { $0.type == item.currency }) {
            cell.configurate(name: item.name, price: priceDefinition(price: price), image: item.wideImage)
        }
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BundlesMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 25
        let heightSize = widthSize * 0.56 + (5 + 17 + 5 + 17 + 5) /* topAnchor + fontSize */
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
            fatalError("Failed to dequeue CollectionHeaderReusableView in BundlesMainViewController")
        }
        headerView.configurate(with: Texts.BundlesPage.header)
        return headerView
    }
}
