//
//  CrewMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit
import AVKit
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "CrewModule", category: "MainController")

/// The view controller for displaying the Crew pack items
final class CrewMainViewController: UIViewController {
    
    // MARK: - Properties
    
    /// List of Crew items to be displayed in the collection view
    private var items = [CrewItem]()
    /// The currently displayed Crew pack, containing information like items, price, and benefits
    private var itemPack = CrewPack.emptyPack
    
    /// The current currency code selected by the user
    private var currentSectionTitle = Texts.Currency.Code.usd
    /// The currency code selected in the menu for displaying prices
    private var selectedSectionTitle = Texts.Currency.Code.usd
    /// Network service responsible for fetching Crew items and related data
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    /// View displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// AVPlayerViewController used to display item preview videos
    private var playerViewController = AVPlayerViewController()
    /// Activity indicator displayed during network requests
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    /// Refresh control for reloading Crew items in the collection view
    private let refreshControl = UIRefreshControl()
    
    /// Navigation bar button for navigating back to the main screen
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// Navigation bar button for displaying the currently selected currency symbol
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .CurrencySymbol.usd
        button.isEnabled = false
        return button
    }()
    
    /// Collection view for displaying Crew items
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
        // Fetches the Crew items if the list is currently empty
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    /// Called when the refresh control is triggered, refreshing the Crew items in the collection view
    @objc private func refreshWithControl() {
        getItems(isRefreshControl: true)
    }
    
    /// Called when the refresh button is pressed in the noInternetView, fetching without displaying the refresh control indicator
    @objc private func refreshWithoutControl() {
        getItems(isRefreshControl: false)
    }
    
    /// Handles tap gestures on the collection view cells, animating the cell and presenting its details
    /// - Parameter gestureRecognizer: The tap gesture recognizer object
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Restarts the video when it reaches the end
    @objc private func videoDidEnd() {
        self.playerViewController.player?.seek(to: .zero, completionHandler: { _ in
            self.playerViewController.player?.play()
        })
    }
    
    // MARK: - Networking
    
    /// Fetches the Crew items from the network
    /// - Parameter isRefreshControl: Indicates whether to show the refresh control indicator
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
                    self?.symbolButton.isEnabled = true
                    self?.menuSetup()
                }
                logger.info("CrewPack loaded successfully")
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.symbolButton.isEnabled = false
                }
                logger.error("CrewPack loading error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches the video for a selected Crew item and displays it
    /// - Parameter index: The index of the item in the collection view
    private func getVideo(index: Int) {
        let item = items[index]
        DispatchQueue.main.async {
            self.collectionView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.2) {
                self.collectionView.alpha = 0.5
            }
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        self.networkService.getItemVideo(id: item.id) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.collectionView.isUserInteractionEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.collectionView.alpha = 1
                }
            }
            switch result {
            case .success(let videoItem):
                DispatchQueue.main.async {
                    guard let url = URL(string: videoItem.video) else {
                        self?.previewSetup(index: index)
                        return
                    }
                    self?.videoSetup(videoURL: url)
                }
                logger.info("Crew item video loading success")
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.previewSetup(index: index)
                }
                logger.error("Crew item video loading error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UserDefaults Currency
    
    /// Manages the storage and retrieval of currency data in UserDefaults
    /// - Parameter request: The action to perform with the currency data (get, save, or delete)
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
    
    // MARK: - Changing Currency Methods
    
    /// Updates the UI and prices when a new currency is selected
    /// - Parameter price: The new currency price to display
    private func updateAll(price: CrewPrice) {
        guard selectedSectionTitle != price.code else { return }
        updateMenuState(for: price.code)
        currentSectionTitle = price.code
        currencyMemoryManager(request: .save)
        
        footerUpdate(price: price)
    }
    
    /// Updates the footer view with the new currency price
    /// - Parameter price: The new currency price to display in the footer
    private func footerUpdate(price: CrewPrice) {
        let visibleSections = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter)
        for indexPath in visibleSections {
            if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? CrewFooterReusableView {
                footerView.changePrice(price: price, firstTime: false)
            }
        }
    }
    
    // MARK: - Cell Animation Method
    
    /// Animates the selection of a collection view cell and presents item details
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            let item = self.items[indexPath.item]
            if item.video {
                self.getVideo(index: indexPath.item)
            } else {
                self.previewSetup(index: indexPath.item)
            }
        }
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform.identity
        })
    }
    
    // MARK: - UI Setups
    
    /// Sets up the navigation bar, including the currency symbol and title
    private func navigationBarSetup() {
        title = Texts.CrewPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
        symbolButton.image = SelectingMethods.selectCurrency(type: currentSectionTitle)
    }
    
    /// Sets up the menu for currency selection and initializes it with the available options
    private func menuSetup() {
        let prices = itemPack.price.filter( {
            SelectingMethods.selectCurrency(type: $0.code) != UIImage()
        } )
        
        var children = [UIAction]()
        for price in prices.sorted(by: { $0.code < $1.code }) {
            let sectionAction = UIAction(title: price.code, image: SelectingMethods.selectCurrency(type: price.code)) { [weak self] action in
                self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectCurrency(type: price.code)
                self?.updateAll(price: price)
            }
            children.append(sectionAction)
            price.code == currentSectionTitle ? sectionAction.state = .on : nil
        }
        let curPrice = prices.first(where: { $0.code == currentSectionTitle }) ?? CrewPrice.emptyPrice
        symbolButton.menu = UIMenu(title: "", children: children)
        footerUpdate(price: curPrice)
    }
    
    /// Updates the menu state to reflect the currently selected currency
    /// - Parameter sectionTitle: The currency code of the newly selected currency
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
    
    /// Prepares and presents a preview of a selected item
    /// - Parameter index: The index of the selected item
    private func previewSetup(index: Int) {
        let item = self.items[index]
        let image = item.image
        let shareImage = item.shareImage
        let name = item.name
        
        let vc = ShopGrantedPreviewViewController(image: image, shareImage: shareImage, name: name)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        self.present(navVC, animated: true)
    }
    
    /// Configures the video player with the specified URL and presents it
    /// - Parameter videoURL: The URL of the video to be displayed
    private func videoSetup(videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
            NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            logger.info("Audio session set up")
        } catch {
            logger.error("Error setting audio session: \(error)")
        }
    }
    
    /// Sets up the collection view with delegates, data sources, and constraints
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
    
    /// Sets up the noInternetView for displaying when there is no internet connection
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
        cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? .common, image: item.image, video: item.video)
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
            // Header setup
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
                fatalError("Failed to dequeue CollectionHeaderReusableView in CrewMainViewController")
            }
            headerView.configurate(with: Texts.CrewPageCell.header)
            return headerView
            
        } else if kind == UICollectionView.elementKindSectionFooter {
            // Footer setup
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
