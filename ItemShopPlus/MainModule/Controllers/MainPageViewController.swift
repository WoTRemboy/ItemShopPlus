//
//  MainPageViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.06.2024.
//

import UIKit
import Kingfisher
import YandexMobileAds

final class MainPageViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let refreshControl = UIRefreshControl()
    
    private let shopPassButtonsView = MainPageMainButtonsView()
    private let otherButtonsView = MainPageOtherView()
    private let crewButton = MainPageCrewView()
    private let bundlesHeaderView = MainPageBundlesHeaderView()
    
    private let networkService = DefaultNetworkService()
    
    private var bundleItems = [BundleItem.emptyBundle, BundleItem.emptyBundle, BundleItem.emptyBundle]
    private var imageLoadTask: DownloadTask?
    private var adHeightConstraint: NSLayoutConstraint = .init()
    
    private let bundleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainPageBundlesCollectionCell.self, forCellWithReuseIdentifier: MainPageBundlesCollectionCell.identifier)
        return collectionView
    }()
    
    private lazy var adView: AdView = {
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 50)
        let adView = AdView(adUnitID: "R-M-8193757-1", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()

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

    @objc func shopTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(ShopViewController(), animated: true)
        }
    }
    
    @objc func battlePassTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(BattlePassMainViewController(), animated: true)
        }
    }
    
    @objc func crewTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(CrewMainViewController(), animated: true)
        }
    }
    
    @objc func bundleTransfer() {
        navigationController?.pushViewController(BundlesMainViewController(), animated: true)
    }
    
    @objc func lootDetailsTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(LootDetailsMainViewController(), animated: true)
        }
    }
    
    @objc func statsTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(StatsMainViewController(), animated: true)
        }
    }
    
    @objc func mapTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(MapPreviewViewController(image: "https://media.fortniteapi.io/images/map.png?showPOI=true"), animated: true)
        }
    }
    
    @objc func settingTransfer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigationController?.pushViewController(SettingsMainViewController(), animated: true)
        }
    }
    
    @objc private func refreshWithControl() {
        getCrewImage()
        getBundles(isRefreshing: true)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: bundleCollectionView)
        if let indexPath = bundleCollectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
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
    
    private func getCrewImage() {
        self.networkService.getCrewItems { [weak self] result in
            switch result {
            case .success(let newPack):
                DispatchQueue.main.async {
                    guard let image = newPack.image else { return }
                    self?.crewButton.updateImage(image: image)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getBundles(isRefreshing: Bool) {
        isRefreshing ? refreshControl.beginRefreshing() : nil
        self.networkService.getBundles { [weak self] result in
            DispatchQueue.main.async {
                isRefreshing ? self?.refreshControl.endRefreshing() : nil
            }
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    self?.bundleItems = newItems
                    guard let collectionView = self?.bundleCollectionView else { return }
                    UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        collectionView.reloadData()
                    }, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
    
    private func mainButtonsSetup() {
        contentView.addSubview(shopPassButtonsView)
        shopPassButtonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shopPassButtonsView.topAnchor.constraint(equalTo: crewButton.bottomAnchor, constant: 16),
            shopPassButtonsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shopPassButtonsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shopPassButtonsView.heightAnchor.constraint(equalToConstant: 57 + (UIScreen.main.bounds.width - 20 * 3) / 2)
        ])
    }
    
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


extension MainPageViewController: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        adHeightConstraint.constant = 50
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        print("YandexMobile " + #function)
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        print("YandexMobile " + #function)
    }
}
