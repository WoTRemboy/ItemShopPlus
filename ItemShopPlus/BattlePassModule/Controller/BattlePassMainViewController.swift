//
//  BattlePassMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.03.2024.
//

import UIKit

/// A view controller manages the main view displaying the Battle Pass items
final class BattlePassMainViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The `BattlePass` model storing information about the current Battle Pass season
    private var battlePass = BattlePass.emptyPass
    /// The title of the currently selected section in the filter menu
    private var selectedSectionTitle = Texts.BattlePassPage.allMenu
    /// Keeps track of the previous number of searched items to manage collection view updates
    private var previousSearchedCount = 0
    
    /// Retrieves the current app language stored in user defaults
    private var appLanguage: String {
        if let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            if let currentLang = userDefault.string(forKey: Texts.LanguageSave.userDefaultsKey) {
                return currentLang
            }
        }
        return Texts.NetworkRequest.language
    }
    
    /// Stores all items available in the Battle Pass
    private var items = [BattlePassItem]()
    /// Stores items that match the user's search query
    private var filteredItems = [BattlePassItem]()
    /// A dictionary categorizing Battle Pass items by their section (page number)
    private var sectionedItems = [Int: [BattlePassItem]]()
    
    /// The service responsible for fetching data related to the Battle Pass
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    /// A view displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// A loading indicator displayed during network requests
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    /// A refresh control for updating the Battle Pass items
    private let refreshControl = UIRefreshControl()
    
    /// Navigation bar back button
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// Navigation bar info button for displaying Battle Pass information
    private let infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .ShopMain.info
        button.action = #selector(infoButtonTapped)
        button.isEnabled = false
        return button
    }()
    
    /// Navigation bar filter button for selecting different Battle Pass sections
    private let filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .FilterMenu.filter
        button.isEnabled = false
        return button
    }()
    
    /// The main collection view displaying Battle Pass items
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(BattlePassMainCollectionViewCell.self, forCellWithReuseIdentifier: BattlePassMainCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    /// Search controller to handle text-based searches for Battle Pass items
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = Texts.BattlePassPage.search
        return searchController
    }()
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        guard items.isEmpty else { return }
        getBattlePass(isRefreshControl: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        view.addSubview(collectionView)
        view.addSubview(noInternetView)
        
        noInternetSetup()
        navigationBarSetup()
        searchControllerSetup()
        collectionViewSetup()
        setupUI()
    }
    
    // MARK: - Actions
    
    /// Presents the `BattlePassInfoViewController` with detailed season information
    @objc private func infoButtonTapped() {
        let vc = BattlePassInfoViewController(seasonName: battlePass.season, video: battlePass.video, beginDate: battlePass.beginDate, endDate: battlePass.endDate)
        let navVC = UINavigationController(rootViewController: vc)
        let fraction = UISheetPresentationController.Detent.custom { context in
            (self.view.frame.height * 0.75 - self.view.safeAreaInsets.bottom * 4)
        }
        navVC.sheetPresentationController?.detents = [fraction]
        present(navVC, animated: true)
    }
    
    /// Called when the refresh control is triggered by a pull-to-refresh gesture
    @objc private func refreshWithControl() {
        if !searchController.isActive {
            getBattlePass(isRefreshControl: true)
        }
    }
    
    /// Called when the refresh control is not necessary
    @objc private func refreshWithoutControl() {
        if !searchController.isActive {
            getBattlePass(isRefreshControl: false)
        }
    }
    
    /// Handles the dismissal of the search controller or resigning of the keyboard
    @objc private func handleTapOutsideKeyboard() {
        guard searchController.isActive else { return }
        if searchController.searchBar.text?.isEmpty == true {
            searchController.dismiss(animated: true)
        } else {
            searchController.searchBar.resignFirstResponder()
        }
        UIView.appearance().isExclusiveTouch = true
    }
    
    /// Handles the tap gesture on a collection view cell, triggering cell selection animation
    /// - Parameter gestureRecognizer: The tap gesture recognizer object
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Animates the selection of a cell and navigates to a detailed view if an item is selected
    /// - Parameter indexPath: The index path of the selected item in the collection view
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let item: BattlePassItem
            let sectionKey = Array(self.sectionedItems.keys).sorted()[indexPath.section]
            if let itemsInSection = self.sectionedItems[sectionKey] {
                (self.filteredItems.count != 0 && self.filteredItems.count != self.items.count) ? (item = self.filteredItems[indexPath.item]) : (item = itemsInSection[indexPath.item])
                self.navigationController?.pushViewController(BattlePassGrantedViewController(item: item), animated: true)
            }
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Networking
    
    /// Fetches the Battle Pass items from the network service
    /// - Parameter isRefreshControl: Determines if the request was triggered by the refresh control
    private func getBattlePass(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            self.searchController.searchBar.isHidden = true
        }
        noInternetView.isHidden = true
        
        self.networkService.getBattlePassItems { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
                self?.selectedSectionTitle = Texts.BattlePassPage.allMenu
            }
            
            switch result {
            case .success(let newPass):
                DispatchQueue.main.async {
                    self?.clearItems()
                    self?.battlePass = newPass
                    self?.items = newPass.items
                    self?.sortingSections(items: newPass.items)
                    
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
                    self?.noInternetView.isHidden = true
                    self?.searchController.searchBar.isHidden = false
                    self?.infoButton.isEnabled = true
                    self?.filterButton.isEnabled = true
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
    
    /// Sorts the items by their section (page number) and stores them in `sectionedItems`
    /// - Parameter items: The list of Battle Pass items to be sorted
    private func sortingSections(items: [BattlePassItem]) {
        for item in items {
            if var sectionItems = self.sectionedItems[item.page] {
                sectionItems.append(item)
                self.sectionedItems[item.page] = sectionItems
            } else {
                self.sectionedItems[item.page] = [item]
            }
        }
    }
    
    /// Filters items by the selected section title and reloads the collection view
    /// - Parameters:
    ///   - sectionTitle: The section title to filter by
    ///   - displayTitle: The display title of the section
    ///   - forAll: Indicates whether to show all items or only items in the selected section
    private func filterItemsBySection(sectionTitle: String, displayTitle: String, forAll: Bool) {
        guard displayTitle != selectedSectionTitle else { return }
        
        sectionedItems.removeAll()
        sortingSections(items: items)
        if !forAll {
            sectionedItems = sectionedItems.filter { headerTitleSetup(page: $0.key) == sectionTitle }
        }
        updateMenuState(for: displayTitle)
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    /// Clears all items stored in the data models
    private func clearItems() {
        items.removeAll()
        sectionedItems.removeAll()
        filteredItems.removeAll()
    }
    
    // MARK: - UI Setups
    
    /// Configures the title and display the header in each section
    /// - Parameter page: The page number of the section
    /// - Returns: A formatted string for the header title
    private func headerTitleSetup(page: Int) -> String {
        switch appLanguage {
        case "tr":
            return "\(page). \(Texts.BattlePassPage.page)"
        default:
            return "\(Texts.BattlePassPage.page) \(page)"
        }
    }
    
    /// Generates the display title for a section in the filter menu
    /// - Parameters:
    ///   - page: The page number of the section
    ///   - lastItemName: The name of the last item in the section
    /// - Returns: A formatted string for the menu title
    private func menuTitleSetup(page: Int, lastItemName: String) -> String {
        return "\(lastItemName)"
    }
    
    /// Configures the navigation bar with buttons and titles
    private func navigationBarSetup() {
        title = Texts.BattlePassPage.title
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        infoButton.target = self
        filterButton.target = self
        navigationItem.rightBarButtonItems = [
            infoButton,
            filterButton
        ]
    }
    
    /// Configures the collection view, setting its delegate, data source, and refresh control
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
    }
    
    /// Configures the search controller and attaches gesture recognizers
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
    
    /// Configures the filter menu for the Battle Pass sections
    private func menuSetup() {
        // All sections filter
        let allAction = UIAction(title: Texts.BattlePassPage.allMenu, image: nil) { [weak self] action in
            self?.filterItemsBySection(sectionTitle: Texts.BattlePassPage.allMenu, displayTitle: Texts.BattlePassPage.allMenu, forAll: true)
            self?.filterButton.image = .FilterMenu.filter
        }
        allAction.state = .on
        var children = [allAction]
        // Filter by specific section
        for section in sectionedItems.sorted(by: { $0.key < $1.key }) {
            let sectionAction = UIAction(title: menuTitleSetup(page: section.key, lastItemName: section.value.last?.name ?? String()), image: nil) { [weak self] action in
                
                self?.filterItemsBySection(sectionTitle: self?.headerTitleSetup(page: section.key) ?? String(), displayTitle: self?.menuTitleSetup(page: section.key, lastItemName: section.value.last?.name ?? "") ?? "", forAll: false)
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
    
    /// Configures the `noInternetView` and attaches action handlers
    private func noInternetSetup() {
        noInternetView.isHidden = true
        noInternetView.reloadButton.addTarget(self, action: #selector(refreshWithoutControl), for: .touchUpInside)
        noInternetView.configurate()
    }
    
    /// Sets up the UI layout constraints for the `collectionView` and `noInternetView`
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
}

// MARK: - UISearchResultsUpdating & UISearchControllerDelegate

extension BattlePassMainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filteredItems = items
        
        if let searchText = searchController.searchBar.text {
            filteredItems = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            if filteredItems.count != previousSearchedCount || (searchText.isEmpty && collectionView.visibleCells.count == 0) || (!searchText.isEmpty && filteredItems.count == 0) {
                UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.collectionView.reloadData()
                }, completion: nil)
                previousSearchedCount = filteredItems.count
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

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension BattlePassMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        return inSearchMode ? 1 : sectionedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        let sectionKey = Array(sectionedItems.keys).sorted()[section]
        return inSearchMode ? filteredItems.count : sectionedItems[sectionKey]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BattlePassMainCollectionViewCell.identifier, for: indexPath) as? BattlePassMainCollectionViewCell else {
            fatalError("Failed to dequeue BattlePassMainCollectionViewCell in BattlePassMainViewController")
        }
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        
        if inSearchMode {
            // Display the search results
            let item = filteredItems[indexPath.item]
            cell.configurate(name: item.name, type: String(item.price), image: item.image, payType: item.payType, video: item.video != nil)
        } else {
            // Display sorted by sections items
            let sectionKey = Array(sectionedItems.keys).sorted()[indexPath.section]
            if let itemsInSection = sectionedItems[sectionKey] {
                let item = itemsInSection[indexPath.item]
                cell.configurate(name: item.name, type: String(item.price), image: item.image, payType: item.payType, video: item.video != nil)
            }
        }
        
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard searchController.isActive else { return }
        if searchController.searchBar.text?.isEmpty == true {
            // Dismiss isSearching status
            searchController.dismiss(animated: false)
        } else {
            // Hide the keyboard
            searchController.searchBar.resignFirstResponder()
        }
        UIView.appearance().isExclusiveTouch = true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BattlePassMainViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        // Section or Search result header
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
            fatalError("Failed to dequeue CollectionHeaderReusableView in BattlePassMainViewController")
        }
        let text = searchController.searchBar.text ?? ""
        let inSearchMode = searchController.isActive && !text.isEmpty
        let count = filteredItems.count
        let sectionKey = Array(sectionedItems.keys).sorted()[indexPath.section]
        
        inSearchMode ? headerView.configurate(with: count > 0 ? Texts.SearchController.result : Texts.SearchController.noResult) : headerView.configurate(with: headerTitleSetup(page: sectionKey))
        return headerView
    }
}
