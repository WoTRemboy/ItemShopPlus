//
//  ShopViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit
import StoreKit
import Kingfisher

/// A view controller responsible for displaying the shop items in a collection view, handling item interactions, and managing data
final class ShopViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The count of items previously searched
    private var previousSearchedCount = 0
    /// The title of the selected section in the shop
    private var selectedSectionTitle = Texts.ShopPage.allMenu
    /// A Boolean value to indicate if the like notification should be shown
    private var likeNotShown = true
    
    /// The array of all shop items
    private var items = [ShopItem]()
    /// The array of items filtered by search or category
    private var filteredItems = [ShopItem]()
    /// A dictionary to store shop items categorized by section titles
    private var sectionedItems = [String: [ShopItem]]()
    /// An array of sorted section keys
    private var sortedKeys = [String]()
    
    /// The service responsible for network requests to fetch shop data
    private let networkService = DefaultNetworkService()
    /// The Core Data manager responsible for handling favorite items
    private let coreDataBase = FavouritesDataBaseManager.shared
    
    // MARK: - UI Elements and Views
    
    /// A view displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// A notification view displayed when an item is added to favorites
    private let favouriteNotification = ShopFavouritesNotificationView()
    /// An activity indicator to show loading progress
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    /// A refresh control used to refresh the shop items
    private let refreshControl = UIRefreshControl()
    
    /// The collection view displaying shop items
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: ShopCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    /// The back button to navigate back to the main view
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// The info button to display additional shop information
    private let infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .ShopMain.info
        button.action = #selector(infoButtonTapped)
        button.isEnabled = false
        return button
    }()
    
    /// The filter button to filter shop items by sections
    private let filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .FilterMenu.filter
        button.isEnabled = false
        return button
    }()
    
    /// The search controller to enable searching through shop items
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = Texts.ShopMainCell.search
        return searchController
    }()
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch shop items if the item list is empty
        if items.isEmpty {
            getShop(isRefreshControl: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Show rating view if conditions are met
        showRaitingViewIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Texts.Pages.shop
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        pageShowCount()
        
        view.addSubview(collectionView)
        view.addSubview(noInternetView)
        
        noInternetSetup()
        collectionViewSetup()
        searchControllerSetup()
        setupUI()
        setupLikeNotificationView()
    }
    
    // MARK: - Actions
    
    /// Refreshes the shop items using the refresh control
    @objc private func refreshWithControl() {
        if !searchController.isActive {
            getShop(isRefreshControl: true)
        }
    }
    
    /// Refreshes the shop items without using the refresh control
    @objc private func refreshWithoutControl() {
        if !searchController.isActive {
            getShop(isRefreshControl: false)
        }
    }
    
    /// Handles cell selection by performing a scaling animation
    /// - Parameter gestureRecognizer: The tap gesture recognizer used to detect the cell tap
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Handles tap gestures outside the search bar to dismiss the keyboard
    @objc private func handleTapOutsideKeyboard() {
        guard searchController.isActive else { return }
        if searchController.searchBar.text?.isEmpty == true {
            searchController.dismiss(animated: true)
        } else {
            searchController.searchBar.resignFirstResponder()
        }
        UIView.appearance().isExclusiveTouch = true
    }
    
    /// Displays additional information when the info button is tapped
    @objc private func infoButtonTapped() {
        let vc = ShopTimerInfoViewController()
        let navVC = UINavigationController(rootViewController: vc)
        let fraction = UISheetPresentationController.Detent.custom { context in
            (self.view.frame.height * 0.9 - self.view.safeAreaInsets.bottom * 4)
        }
        navVC.sheetPresentationController?.detents = [fraction]
        present(navVC, animated: true)
    }
    
    /// Handles favorite button press to toggle the favorite state of an item
    /// - Parameter sender: The button triggering the action
    @objc private func favouriteButtonPress(_ sender: UIButton) {
        guard let cell = sender.superview as? ShopCollectionViewCell,
              let indexPath = collectionView.indexPath(for: cell)
        else { return }
        
        favouriteItemToggle(at: indexPath)
    }
    
    // MARK: - StoreKit raiting
    
    /// Increments and tracks the number of times the shop page has been displayed
    private func pageShowCount() {
        let retrievedInt = UserDefaults.standard.integer(forKey: Texts.ShopPage.countKey)
        let nextStep = retrievedInt + 1
        UserDefaults.standard.set(nextStep, forKey: Texts.ShopPage.countKey)
    }
    
    /// Displays the rating view if the page has been shown a five number of times
    private func showRaitingViewIfNeeded() {
        let retrievedInt = UserDefaults.standard.integer(forKey: Texts.ShopPage.countKey)
        guard retrievedInt == 5 else { return }
        if let windowScene = view.window?.windowScene {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
    
    // MARK: - Networking
    
    /// Fetches shop items from the network
    /// - Parameter isRefreshControl: A Boolean indicating whether the refresh control should be used
    private func getShop(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.searchController.searchBar.isHidden = true
        }
        self.noInternetView.isHidden = true
        
        self.networkService.getShopItems { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
                self?.selectedSectionTitle = Texts.ShopPage.allMenu
            }
            
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    self?.clearItems()
                    self?.noInternetView.isHidden = true
                    self?.searchController.searchBar.isHidden = false
                    
                    // Core Data favourites items implement
                    self?.coreDataBase.loadFromDataBase()
                    self?.checkFavouritesItems(items: newItems, favourites: self?.coreDataBase.items ?? [])
                    
                    self?.infoButton.isEnabled = true
                    self?.filterButton.isEnabled = true
                    
                    guard let collectionView = self?.collectionView else { return }
                    collectionView.isHidden = false
                    if isRefreshControl {
                        // Reload without animation
                        collectionView.reloadData()
                    } else {
                        // Reload with animation
                        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            collectionView.reloadData()
                        }, completion: nil)
                    }
                    self?.menuSetup()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.clearItems()
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = false
                    
                    self?.noInternetView.isHidden = false
                    self?.searchController.searchBar.isHidden = true
                    
                    self?.infoButton.isEnabled = false
                    self?.filterButton.isEnabled = false
                }
                print(error)
            }
        }
    }
    
    // MARK: - Items Management Methods
    
    /// Sorts the given shop items into sections based on their `section` property
    /// - Parameter items: The array of `ShopItem` objects to be sorted
    private func sortingSections(items: [ShopItem]) {
        sectionedItems.removeAll()
        for item in items {
            if var sectionItems = self.sectionedItems[item.section] {
                sectionItems.append(item)
                self.sectionedItems[item.section] = sectionItems
            } else {
                self.sectionedItems[item.section] = [item]
            }
        }
        sortingKeys()
    }
    
    /// Sorts the section keys for displaying sections in a specific order
    private func sortingKeys() {
        sortedKeys = Array(sectionedItems.keys).sorted {
            if $0 == Texts.ShopPage.jamTracks {
                return false
            } else if $1 == Texts.ShopPage.jamTracks {
                return true
            }
            return $0 < $1
        }
    }
    
    /// Filters items based on the selected section title and updates the collection view
    /// - Parameters:
    ///   - sectionTitle: The title of the section to filter items by
    ///   - forAll: A Boolean value indicating whether to display all items or just the ones in the specified section
    private func filterItemsBySection(sectionTitle: String, forAll: Bool) {
        guard sectionTitle != selectedSectionTitle else { return }
        
        sectionedItems.removeAll()
        sortingSections(items: items)
        if !forAll {
            sectionedItems = sectionedItems.filter { $0.key == sectionTitle }
        }
        updateMenuState(for: sectionTitle)
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    /// Compares the items in the shop with the favorites and updates their `isFavourite` state
    /// - Parameters:
    ///   - items: The array of shop items to be checked
    ///   - favourites: The array of favorite items retrieved from the database
    private func checkFavouritesItems(items: [ShopItem], favourites: [ShopItem]) {
        self.items = items
        let favouriteSet = Set(favourites)
        for i in 0..<items.count {
            if favouriteSet.contains(items[i]) {
                self.items[i].isFavourite = true
            } else {
                self.items[i].isFavourite = false
            }
        }
        sortingSections(items: self.items)
    }
    
    /// Toggles the favorite state of a shop item and updates the database accordingly
    /// - Parameter indexPath: The index path of the item to be toggled
    private func favouriteItemToggle(at indexPath: IndexPath) {
        var item = ShopItem.emptyShopItem
        let sectionKey = sortedKeys[indexPath.section]
        if let itemsInSection = sectionedItems[sectionKey] {
            if filteredItems.count != 0 && filteredItems.count != self.items.count {
                item = filteredItems[indexPath.item]
                let index = items.firstIndex(where: { $0.id == item.id }) ?? 0
                items[index].favouriteToggle()
                filteredItems[indexPath.item].favouriteToggle()
                
                let sectioned = sectionedItems[item.section]
                let sectionedIndex = sectioned?.firstIndex(where: { $0.id == item.id }) ?? 0
                sectionedItems[item.section]?[sectionedIndex].favouriteToggle()
            } else {
                item = itemsInSection[indexPath.item]
                let index = items.firstIndex(where: { $0.id == item.id }) ?? 0
                items[index].favouriteToggle()
                sectionedItems[sectionKey]?[indexPath.item].favouriteToggle()
            }
        }
        
        if item.isFavourite {
            coreDataBase.removeFromDataBase(at: item.id)
        } else {
            coreDataBase.insertToDataBase(item: item)
            showLikeNotification()
        }
    }
    
    /// Clears all shop items and their sections
    private func clearItems() {
        items.removeAll()
        filteredItems.removeAll()
        sectionedItems.removeAll()
    }
    
    // MARK: - Animating Cell Method
    
    /// Animates the selection of a cell and navigates to the details view of the selected item
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let item: ShopItem
            let sectionKey = self.sortedKeys[indexPath.section]
            if let itemsInSection = self.sectionedItems[sectionKey] {
                (self.filteredItems.count != 0 && self.filteredItems.count != self.items.count) ? (item = self.filteredItems[indexPath.item]) : (item = itemsInSection[indexPath.item])
                self.navigationController?.pushViewController(ShopGrantedViewController(bundle: item), animated: true)
            }
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - UI Setups
    
    /// Sets up the navigation bar with necessary buttons and title settings
    private func navigationBarSetup() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        infoButton.target = self
        filterButton.target = self
        
        navigationItem.rightBarButtonItems = [
            infoButton,
            filterButton
        ]
    }
    
    /// Configures the filter menu and adds section filters based on the shop items
    private func menuSetup() {
        let allAction = UIAction(title: Texts.ShopPage.allMenu, image: nil) { [weak self] action in
            self?.filterItemsBySection(sectionTitle: Texts.ShopPage.allMenu, forAll: true)
            self?.filterButton.image = .FilterMenu.filter
        }
        allAction.state = .on
        var children = [allAction]
        for section in sortedKeys {
            let sectionAction = UIAction(title: section, image: nil) { [weak self] action in
                self?.filterItemsBySection(sectionTitle: section, forAll: false)
                self?.filterButton.image = .FilterMenu.filledFilter
            }
            
            children.append(sectionAction)
        }
        filterButton.menu = UIMenu(title: "", children: children)
        filterButton.image = .FilterMenu.filter
    }
    
    /// Updates the menu state to reflect the currently selected section
    /// - Parameter sectionTitle: The title of the currently selected section
    private func updateMenuState(for sectionTitle: String) {
        if let currentAction = filterButton.menu?.children.first(where: { $0.title == sectionTitle }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = filterButton.menu?.children.first(where: { $0.title == selectedSectionTitle }) as? UIAction {
            previousAction.state = .off
        }
        selectedSectionTitle = sectionTitle
    }
    
    /// Configures the collection view with the refresh control and sets the delegate and data source
    private func collectionViewSetup() {
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
    }
    
    /// Configures the search controller with necessary delegates and appearance settings
    private func searchControllerSetup() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Configures the no internet view to be hidden initially and sets the reload button action
    private func noInternetSetup() {
        noInternetView.isHidden = true
        noInternetView.reloadButton.addTarget(self, action: #selector(refreshWithoutControl), for: .touchUpInside)
        noInternetView.configurate()
    }
    
    /// Sets up the layout constraints and adds the collection view and no internet view to the view hierarchy
    private func setupUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
    
    /// Sets up the favorite notification view and positions it at the bottom of the screen
    private func setupLikeNotificationView() {
        view.addSubview(favouriteNotification)
        favouriteNotification.translatesAutoresizingMaskIntoConstraints = false
        favouriteNotification.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            favouriteNotification.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteNotification.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            favouriteNotification.heightAnchor.constraint(equalToConstant: 60),
            favouriteNotification.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 100)
        ])
        
        favouriteNotification.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    /// Displays the favorite notification with an animation
    private func showLikeNotification() {
        guard likeNotShown else { return }
        let bottomOffset: CGFloat = view.safeAreaInsets.bottom > 0 ? 100 : 116
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.favouriteNotification.transform = CGAffineTransform(translationX: 0, y: -bottomOffset)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseOut], animations: {
                self.favouriteNotification.alpha = 0
            }, completion: nil)
        }
        likeNotShown = false
    }
}

// MARK: - UISearchResultsUpdating & UISearchControllerDelegate

extension ShopViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filteredItems = items
        
        if let searchText = searchController.searchBar.text {
            filteredItems = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
            // Reloads collection view only if the search result count has changed
            if filteredItems.count != previousSearchedCount || (searchText.isEmpty && collectionView.visibleCells.count == 0) || (!searchText.isEmpty && filteredItems.count == 0) {
                UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.collectionView.reloadData()
                }, completion: nil)
                previousSearchedCount = filteredItems.count
            }
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // Disables exclusive touch when the search controller is presented
        UIView.appearance().isExclusiveTouch = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // Re-enables exclusive touch when the search controller is dismissed
        UIView.appearance().isExclusiveTouch = true
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        return inSearchMode ? 1 : sectionedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        sortingKeys()
        let sectionKey = sortedKeys[section]
        return inSearchMode ? filteredItems.count : sectionedItems[sectionKey]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.identifier, for: indexPath) as? ShopCollectionViewCell else {
            fatalError("Failed to dequeue ShopCollectionViewCell in ShopViewController")
        }
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        let width = view.frame.width / 2 - 25
        
        // Configure the cell based on whether the user is in search mode or viewing all items
        if inSearchMode {
            let item = filteredItems[indexPath.item]
            cell.configurate(with: item.images, item.name, item.price, item.regularPrice, item.banner, item.video, favourite: item.isFavourite, grantedCount: item.granted.filter({ $0?.name != "" }).count, width)
        } else {
            let sectionKey = sortedKeys[indexPath.section]
            if let itemsInSection = sectionedItems[sectionKey] {
                let item = itemsInSection[indexPath.item]
                cell.configurate(with: item.images, item.name, item.price, item.regularPrice, item.banner, item.video, favourite: item.isFavourite, grantedCount: item.granted.filter({ $0?.name != "" }).count, width)
            }
        }
        
        // Add tap gesture recognizer and favorite button action to the cell
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        cell.favouriteButton.addTarget(self, action: #selector(favouriteButtonPress), for: .touchUpInside)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard searchController.isActive else { return }
        searchController.searchBar.resignFirstResponder()
        UIView.appearance().isExclusiveTouch = true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
            fatalError("Failed to dequeue ShopCollectionReusableView in ShopViewController")
        }
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        sortingKeys()
        let sectionKey = sortedKeys[indexPath.section]
        let count = filteredItems.count
        inSearchMode ? headerView.configurate(with: count > 0 ? Texts.SearchController.result : Texts.SearchController.noResult) : headerView.configurate(with: sectionKey)
        return headerView
    }
}
