//
//  MainPageViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.06.2024.
//

import UIKit
import OSLog
import Kingfisher
import YandexMobileAds

/// A log object to organize messages
private let logger = Logger(subsystem: "MainModule", category: "Controllers")

/// The main page view controller displaying various buttons, banners, and content sections
final class MainPageViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// The scroll view for content layout
    private let scrollView = UIScrollView()
    /// The content view inside the scroll view
    private let contentView = UIView()
    /// The refresh control for the scroll view
    private let refreshControl = UIRefreshControl()
    
    /// The main buttons view containing shop, battle pass and stats buttons
    private let shopPassButtonsView = MainPageMainButtonsView()
    /// The "Other" buttons view containing additional actions like map, armory, settings and favorites
    private let otherButtonsView = MainPageOtherView()
    /// The crew button view
    private let crewButton = MainPageCrewView()
    /// The header view for the bundles section
    private let bundlesHeaderView = MainPageBundlesHeaderView()
    
    /// The network service responsible for fetching data
    private let networkService = DefaultNetworkService()
    
    /// The collection of bundle items
    private var bundleItems = [BundleItem.emptyBundle, BundleItem.emptyBundle, BundleItem.emptyBundle]
    /// The image download task for asynchronous loading
    private var imageLoadTask: DownloadTask?
    /// The height constraint for the ad view
    private var adHeightConstraint: NSLayoutConstraint = .init()
    
    /// The collection view displaying bundles in a horizontal layout
    private let bundleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainPageBundlesCollectionCell.self, forCellWithReuseIdentifier: MainPageBundlesCollectionCell.identifier)
        return collectionView
    }()
    
    /// The ad view displaying inline banner ads
    private lazy var adView: AdView = {
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 50)
        let adView = AdView(adUnitID: "R-M-8193757-1", adSize: adSize)
        adView.layer.cornerRadius = 10
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.Pages.main
        view.backgroundColor = .backDefault
        
        UIView.appearance().isExclusiveTouch = true
        
        scrollViewSetup()
        contentViewSetup()
        
        crewImageViewSetup()
        mainButtonsSetup()
        adBannerSetup()
        bundlesHeaderViewSetup()
        bundleCollectionViewSetup()
        otherButtonsSetup()
        
        getCrewImage()
        getBundles(isRefreshing: false)
    }
    
    // MARK: - Navigation Methods
    
    /// Navigates to the shop page
    @objc func shopTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(ShopViewController(), animated: true)
        }
    }
    
    /// Navigates to the battle pass page
    @objc func battlePassTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(BattlePassMainViewController(), animated: true)
        }
    }
    
    /// Navigates to the crew page
    @objc func crewTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(CrewMainViewController(), animated: true)
        }
    }
    
    /// Navigates to the bundles page
    @objc func bundleTransfer() {
        navigationController?.pushViewController(BundlesMainViewController(), animated: true)
    }
    
    /// Navigates to the loot details page
    @objc func lootDetailsTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(LootDetailsMainViewController(), animated: true)
        }
    }
    
    /// Navigates to the stats page
    @objc func statsTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(StatsMainViewController(), animated: true)
        }
    }
    
    /// Navigates to the map preview page
    @objc func mapTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(MapPreviewViewController(image: "https://media.fortniteapi.io/images/map.png?showPOI=true"), animated: true)
        }
    }
    
    /// Navigates to the favorites items page
    @objc func favouritesTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(FavouritesItemsViewController(), animated: true)
        }
    }
    
    /// Navigates to the settings page
    @objc func settingTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(SettingsMainViewController(), animated: true)
        }
    }
    
    // MARK: - Refresh Control
    
    /// Refreshes the content when the refresh control is activated
    @objc private func refreshWithControl() {
        getCrewImage()
        getBundles(isRefreshing: true)
    }
    
    // MARK: - Gesture Handlers
    
    /// Handles the tap gesture on the bundle collection view
    /// - Parameter gestureRecognizer: The gesture recognizer that triggered the action
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: bundleCollectionView)
        if let indexPath = bundleCollectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Animates the selection of a bundle cell and navigates to its detail page
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        let cell = bundleCollectionView.cellForItem(at: indexPath)
        
        let item = bundleItems[indexPath.item]
        let vc = BundlesDetailsViewController(item: item, fromMainPage: true)
        
        UIView.animate(withDuration: 0.1, animations: {
            cell?.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            self.navigationController?.pushViewController(vc, animated: true)
            UIView.animate(withDuration: 0.1, animations: {
                cell?.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - Data Fetching Methods
    
    /// Fetches the crew image from the network service
    private func getCrewImage() {
        self.networkService.getCrewItems { [weak self] result in
            switch result {
            case .success(let newPack):
                DispatchQueue.main.async {
                    guard let image = newPack.image else { return }
                    self?.crewButton.updateImage(image: image)
                }
                logger.info("Crew image fetched successfully")
            case .failure(let error):
                logger.error("Crew image loading error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches the bundles from the network service
    /// - Parameter isRefreshing: A Boolean indicating whether the refresh control is active
    private func getBundles(isRefreshing: Bool) {
        // Check if refresh control process is necessary
        isRefreshing ? refreshControl.beginRefreshing() : nil
        self.networkService.getBundles { [weak self] result in
            DispatchQueue.main.async {
                isRefreshing ? self?.refreshControl.endRefreshing() : nil
            }
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    // Add received items & update collection view content
                    self?.bundleItems = newItems
                    guard let collectionView = self?.bundleCollectionView else { return }
                    UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        collectionView.reloadData()
                    }, completion: nil)
                    logger.info("Bundles fetched successfully")
                }
            case .failure(let error):
                logger.error("Bundles loading error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UI Setup Methods
    
    /// Sets up the scroll view
    private func scrollViewSetup() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    /// Sets up the content view inside the scroll view
    private func contentViewSetup() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    /// Sets up the crew image view
    private func crewImageViewSetup() {
        contentView.addSubview(crewButton)
        crewButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            crewButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            crewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            crewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            crewButton.heightAnchor.constraint(equalTo: crewButton.widthAnchor, multiplier: 9/16)
        ])
    }
    
    /// Sets up the main buttons view
    private func mainButtonsSetup() {
        contentView.addSubview(shopPassButtonsView)
        shopPassButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shopPassButtonsView.topAnchor.constraint(equalTo: crewButton.bottomAnchor, constant: 16),
            shopPassButtonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shopPassButtonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shopPassButtonsView.heightAnchor.constraint(equalToConstant: 57 + (UIScreen.main.bounds.width - 16 * 4) / 3 + 27)
        ])
    }
    
    /// Sets up the ad banner view
    private func adBannerSetup() {
        contentView.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: shopPassButtonsView.bottomAnchor, constant: 10),
            adView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        adHeightConstraint = adView.heightAnchor.constraint(equalToConstant: 0)
        adHeightConstraint.isActive = true
        
        adView.loadAd()
    }
    
    /// Sets up the bundles header view
    private func bundlesHeaderViewSetup() {
        contentView.addSubview(bundlesHeaderView)
        bundlesHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bundlesHeaderView.topAnchor.constraint(equalTo: adView.bottomAnchor, constant: 16),
            bundlesHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bundlesHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bundlesHeaderView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    /// Sets up the bundle collection view
    private func bundleCollectionViewSetup() {
        contentView.addSubview(bundleCollectionView)
        bundleCollectionView.delegate = self
        bundleCollectionView.dataSource = self
        bundleCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bundleCollectionView.topAnchor.constraint(equalTo: bundlesHeaderView.bottomAnchor, constant: 16),
            bundleCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bundleCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bundleCollectionView.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    /// Sets up the "Other" buttons view
    private func otherButtonsSetup() {
        contentView.addSubview(otherButtonsView)
        otherButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            otherButtonsView.topAnchor.constraint(equalTo: bundleCollectionView.bottomAnchor, constant: 16),
            otherButtonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            otherButtonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            otherButtonsView.heightAnchor.constraint(equalToConstant: 57 + (UIScreen.main.bounds.width - 16 * 2 + 8 * 3) / 4),
            otherButtonsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UICollectionViewDelegate & DataSource

extension MainPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bundleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainPageBundlesCollectionCell.identifier, for: indexPath) as? MainPageBundlesCollectionCell else {
            fatalError("Failed to dequeue BundleCollectionViewCell in BundleMainViewController")
        }
        
        let item = bundleItems[indexPath.item]
        cell.configurate(image: item.bannerImage)
        
        // Do not transfer if bundle is not loaded
        if !item.bannerImage.isEmpty {
            let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
            cell.addGestureRecognizer(pressGesture)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainPageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
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
}

// MARK: - AdViewDelegate

extension MainPageViewController: AdViewDelegate {
    /// Called when the ad view successfully loads an ad
    /// - Parameter adView: The ad view that loaded an ad
    func adViewDidLoad(_ adView: AdView) {
        adHeightConstraint.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        logger.info("YandexMobile successfully loaded")
    }
    
    /// Called when the ad view fails to load an ad
    /// - Parameters:
    ///   - adView: The ad view that failed to load an ad
    ///   - error: The error that occurred during loading
    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        logger.error("YandexMobile got error while loading")
    }
}
