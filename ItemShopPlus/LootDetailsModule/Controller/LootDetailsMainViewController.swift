//
//  LootDetailsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import UIKit

///  The main view controller for displaying a list of loot details, supporting filtering and searching functionality
final class LootDetailsMainViewController: UIViewController {
    
    // MARK: - Properties
    
    /// A list of all loot items
    private var items = [LootDetailsItem]()
    /// A list of grouped loot items by name
    private var namedItems = [LootNamedItems]()
    /// A list of filtered and grouped loot items
    private var filteredGroupedItems = [LootNamedItems]()
    /// Dictionary grouping loot items by type or category
    private var groupedItems = [String: [LootNamedItems]]()
    
    /// Tracks the previous count of searched results to handle UI updates
    private var previousSearchedCount = 0
    /// The currently selected section title for filtering
    private var selectedSectionTitle = Texts.ShopPage.allMenu
    /// Array of search tags for filtering items
    private var tags = [String]()
    
    /// A network service instance for fetching loot details
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements & Views
    
    /// A view displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// Activity indicator to show loading state
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    /// Refresh control to reload the list of items
    private let refreshControl = UIRefreshControl()
    
    /// Back button for navigation
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// Filter button to trigger filtering options
    private let filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .FilterMenu.filter
        button.isEnabled = false
        return button
    }()
    
    /// The main collection view to display loot items
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
    
    /// Search controller to handle item search functionality
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = Texts.ShopMainCell.search
        return searchController
    }()
    
    // MARK: - Lifecycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        searchTags()
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
        searchControllerSetup()
        getItems(isRefreshControl: false)
    }
    
    // MARK: - Refresh Methods
    
    /// Refresh items when triggered by the refresh control
    @objc private func refreshWithControl() {
        if !searchController.isActive {
            getItems(isRefreshControl: true)
        }
    }
    
    /// Refresh items when triggered without the refresh control
    @objc private func refreshWithoutControl() {
        if !searchController.isActive {
            getItems(isRefreshControl: false)
        }
    }
    
    // MARK: - Handling User Interactions
    
    /// Handles cell selection by animating the cell and navigating to detailed loot view
    /// - Parameter gestureRecognizer: The tap gesture recognizer object
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Handles tap gesture outside the search bar to dismiss the keyboard
    @objc private func handleTapOutsideKeyboard() {
        guard searchController.isActive else { return }
        if searchController.searchBar.text?.isEmpty == true {
            searchController.dismiss(animated: true)
        } else {
            searchController.searchBar.resignFirstResponder()
        }
        UIView.appearance().isExclusiveTouch = true
    }
    
    // MARK: - Grouping and Filtering
    
    /// Groups loot items by their name and type
    /// - Parameter items: The list of loot items to be grouped
    private func groupLootItems(items: [LootDetailsItem]) {
        var namedItems = [String: [LootDetailsItem]]()
        let clearItems = uniqueItems(items: items)
        
        self.namedItems.removeAll()
        self.groupedItems.removeAll()
        
        for item in clearItems {
            if namedItems[item.name] == nil {
                namedItems[item.name] = [item]
            } else {
                namedItems[item.name]?.append(item)
            }
        }
        for item in namedItems {
            let namedItem = LootNamedItems(name: item.key, items: item.value)
            self.namedItems.append(namedItem)
            
            let type = item.value.first?.searchTags.filter { tags.contains($0) }.last ?? Texts.LootDetailsStats.Tags.misc
            groupedItems[type, default: []].append(namedItem)
            groupedItems[type]?.sort { $0.name < $1.name }
        }
        self.namedItems.sort { $0.name < $1.name }
    }
    
    /// Removes duplicate loot items based on their name and rarity
    /// - Parameter items: The list of loot items to be filtered for unique values
    /// - Returns: A list of unique loot items
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
    
    /// Sets up the search tags used for filtering loot items
    private func searchTags() {
        tags = [Texts.LootDetailsStats.Tags.pistols,
                Texts.LootDetailsStats.Tags.assault,
                Texts.LootDetailsStats.Tags.shotgun,
                Texts.LootDetailsStats.Tags.sniper,
                Texts.LootDetailsStats.Tags.bow,
                Texts.LootDetailsStats.Tags.blade,
                Texts.LootDetailsStats.Tags.launcher,
                Texts.LootDetailsStats.Tags.gadget,
                Texts.LootDetailsStats.Tags.heal,
                Texts.LootDetailsStats.Tags.misc]
    }
        
    /// Updates the filter and reloads the collection view based on the selected section title
    /// - Parameters:
    ///   - sectionTitle: The title of the section to filter items by
    ///   - forAll: A boolean indicating whether to filter for all sections or just a specific one
    private func filterItemsByMenu(sectionTitle: String, forAll: Bool) {
        guard sectionTitle != selectedSectionTitle else { return }
        
        updateMenuState(for: sectionTitle)
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    // MARK: - Animations
    
    /// Animates the cell selection and pushes a detailed loot view based on the selected item
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let items: [LootDetailsItem]
        if filteredGroupedItems.count != 0 && filteredGroupedItems.count != groupedItems.count {
            items = filteredGroupedItems[indexPath.item].items
        } else {
            var sectionKey = selectedSectionTitle
            if selectedSectionTitle == Texts.ShopPage.allMenu {
                sectionKey = tags[indexPath.section]
            }
            let itemsInSection = groupedItems[sectionKey] ?? []
            items = itemsInSection[indexPath.item].items
        }
        
        guard items.count > 0 else { return }
        
        let vc: UIViewController
        if items.count > 1 {
            vc = LootDetailsRarityViewController(items: items)
        } else {
            vc = LootDetailsStatsViewController(item: items[0], fromRarity: false)
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
    
    // MARK: - Data Fetching
    
    /// Fetches loot items from the network service and handles UI updates
    /// - Parameter isRefreshControl: A boolean indicating whether the data is being fetched via a refresh control or not
    private func getItems(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.searchController.searchBar.isHidden = true
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
                self?.selectedSectionTitle = Texts.ShopPage.allMenu
            }
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    self?.items = newItems
                    self?.groupLootItems(items: newItems)
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
                    self?.noInternetView.isHidden = true
                    self?.filterButton.isEnabled = true
                    self?.searchController.searchBar.isHidden = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.filterButton.isEnabled = false
                    self?.searchController.searchBar.isHidden = true
                }
                print(error)
            }
        }
    }
    
    // MARK: - Menu & Searching Setup
    
    /// Configures the menu for filtering loot items
    private func menuSetup() {
        let allAction = UIAction(title: Texts.ShopPage.allMenu, image: nil) { [weak self] action in
            self?.filterItemsByMenu(sectionTitle: Texts.ShopPage.allMenu, forAll: true)
            self?.filterButton.image = .FilterMenu.filter
        }
        allAction.state = .on
        var children = [allAction]
        
        searchTags()
        for section in tags {
            let sectionAction = UIAction(title: SelectingMethods.selectWeaponTag(tag: section), image: nil) { [weak self] action in
                self?.filterItemsByMenu(sectionTitle: section, forAll: false)
                self?.filterButton.image = .FilterMenu.filledFilter
            }
            
            children.append(sectionAction)
        }
        filterButton.menu = UIMenu(title: "", children: children)
        filterButton.image = .FilterMenu.filter
    }
    
    /// Updates the filter menu state to reflect the currently selected section
    /// - Parameter sectionTitle: The title of the section that has been selected
    private func updateMenuState(for sectionTitle: String) {
        if let currentAction = filterButton.menu?.children.first(where: { $0.title == SelectingMethods.selectWeaponTag(tag: sectionTitle) }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = filterButton.menu?.children.first(where: { $0.title == SelectingMethods.selectWeaponTag(tag: selectedSectionTitle) }) as? UIAction {
            previousAction.state = .off
        }
        selectedSectionTitle = sectionTitle
    }
    
    /// Sets up the search controller for filtering loot items by name
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
    
    // MARK: - UI Setup
    
    /// Sets up the navigation bar with a title and filter button
    private func navigationBarSetup() {
        title = Texts.LootDetailsMain.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        filterButton.target = self
        navigationItem.rightBarButtonItem = filterButton
    }
    
    /// Sets up the collection view to display loot items and handle refreshing
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
    
    /// Sets up the view that is displayed when there is no internet connection
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

// MARK: - UISearchResultsUpdating & UISearchControllerDelegate

extension LootDetailsMainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filteredGroupedItems = namedItems
        if let searchText = searchController.searchBar.text {
            // Filter the items based on the search text entered by the user
            filteredGroupedItems = namedItems.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            if filteredGroupedItems.count != previousSearchedCount || (searchText.isEmpty && collectionView.visibleCells.count == 0) || (!searchText.isEmpty && filteredGroupedItems.count == 0) {
                // Update the collection view if the filtered result changes or certain conditions are met
                UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.collectionView.reloadData()
                }, completion: nil)
                previousSearchedCount = filteredGroupedItems.count
            }
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.appearance().isExclusiveTouch = false
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.appearance().isExclusiveTouch = true
    }
}


// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension LootDetailsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        return inSearchMode || filterButton.menu?.selectedElements.first?.title != Texts.ShopPage.allMenu ? 1 : tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        var sectionKey = selectedSectionTitle
        if selectedSectionTitle == Texts.ShopPage.allMenu {
            sectionKey = tags[section]
        }
        let groupedCount = groupedItems[sectionKey]?.count ?? 0
        return inSearchMode ? filteredGroupedItems.count : groupedCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LootDetailsMainCollectionViewCell.identifier, for: indexPath) as? LootDetailsMainCollectionViewCell else {
            fatalError("Failed to dequeue LootDetailsMainCollectionViewCell in LootDetailsMainViewController")
        }
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        
        let groupedItem: [LootDetailsItem]
        var sectionKey = selectedSectionTitle
        if inSearchMode {
            groupedItem = filteredGroupedItems[indexPath.item].items
        } else {
            if selectedSectionTitle == Texts.ShopPage.allMenu {
                sectionKey = tags[indexPath.section]
            }
            let itemsInSection = self.groupedItems[sectionKey] ?? []
            groupedItem = itemsInSection[indexPath.item].items
        }
        let item = groupedItem.first ?? LootDetailsItem.emptyLootDetails
        cell.configurate(type: .weapon, name: item.name, image: item.mainImage, firstStat: Double(groupedItem.count), secondStat: Double(item.stats.availableStats))
        
        // Adds a tap gesture recognizer to handle cell selection
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard searchController.isActive else { return }
        searchController.searchBar.resignFirstResponder()
        UIView.appearance().isExclusiveTouch = true
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
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        
        var sectionKey = selectedSectionTitle
        if selectedSectionTitle == Texts.ShopPage.allMenu {
            sectionKey = tags[indexPath.section]
        }
        let count = filteredGroupedItems.count
        inSearchMode ? headerView.configurate(with: count > 0 ? Texts.SearchController.result : Texts.SearchController.noResult) : headerView.configurate(with: SelectingMethods.selectWeaponTag(tag: sectionKey))
        return headerView
    }
}
