//
//  ShopGrantedViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.01.2024.
//

import UIKit
import AVKit

final class ShopGrantedViewController: UIViewController {
    
    // MARK: - Properties
    
    private var items = [GrantedItem?]()
    private let bundle: ShopItem
    
    private var originalTitleAttributes: [NSAttributedString.Key : Any]?
    private var isPresentedFullScreen = false
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    private var playerViewController = AVPlayerViewController()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionRarityCell.self, forCellWithReuseIdentifier: CollectionRarityCell.identifier)
        collectionView.register(ShopGrantedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ShopGrantedCollectionReusableView.identifier)
        return collectionView
    }()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToShop
        return button
    }()
    
    // MARK: - Initialization
    
    init(bundle: ShopItem) {
        self.bundle = bundle
        for grant in bundle.granted {
            if grant?.name.isEmpty == false {
                self.items.append(grant)
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = bundle.name
        view.backgroundColor = .BackColors.backDefault
        
        navigationItem.largeTitleDisplayMode = .always
        originalTitleAttributes = navigationController?.navigationBar.largeTitleTextAttributes
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isPresentedFullScreen = false
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isPresentedFullScreen {
            navigationController?.navigationBar.largeTitleTextAttributes = originalTitleAttributes
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    @objc private func videoToRepeat() {
        self.playerViewController.player?.seek(to: .zero, completionHandler: { _ in
            self.playerViewController.player?.play()
        })
    }
    
    @objc private func videoToDismiss() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        self.playerViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Rows and Cell Animation Methods
    
    private func countRows() -> Int {
        var count = 3 // first + last + out dates
        if !bundle.description.isEmpty { count += 1 }
        if bundle.series != nil { count += 1 }
        
        return count
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            if self.items.count > 0 {
                if let video = self.items[indexPath.item]?.video, let videoURL = URL(string: video) {
                    self.videoSetup(videoURL: videoURL, repeatable: false)
                } else  {
                    let item = self.items[indexPath.item]
                    if item?.typeID == "outfit" {
                        self.getVideo(index: indexPath.item)
                    } else {
                        self.previewSetup(index: indexPath.item)
                    }
                }
            } else {
                self.previewSetup(index: 0)
            }
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
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
        self.networkService.getItemVideo(id: item?.id ?? "") { [weak self] result in
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
                    self?.videoSetup(videoURL: url, repeatable: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.previewSetup(index: index)
                }
                print(error)
            }
        }
    }
    
    // MARK: - UI Setup
    
    private func videoSetup(videoURL: URL, repeatable: Bool) {
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        
        self.isPresentedFullScreen = true
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
            if repeatable {
                NotificationCenter.default.addObserver(self, selector: #selector(self.videoToRepeat), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            } else {
                NotificationCenter.default.addObserver(self, selector: #selector(self.videoToDismiss), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session:", error)
        }
    }
    
    private func previewSetup(index: Int) {
        var itemImage = self.bundle.images.first?.image ?? ""
        var itemName = self.bundle.name
        if !self.items.isEmpty {
            let item = self.items[index]
            itemImage = item?.image ?? ""
            itemName = item?.name ?? ""
        }
        self.isPresentedFullScreen = true
        
        let vc = ShopGrantedPreviewViewController(image: itemImage, name: itemName)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        self.present(navVC, animated: true)
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
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ShopGrantedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count != 0 ? items.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionRarityCell.identifier, for: indexPath) as? CollectionRarityCell else {
            fatalError("Failed to dequeue ShopGrantedCollectionViewCell in ShopGrantedViewController")
        }
        if items.count > 0, let item = items[indexPath.item] {
            cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? .common, image: item.image, video: item.video != nil || item.typeID == "outfit")
        } else {
            cell.configurate(name: bundle.name, type: bundle.type, rarity: bundle.rarity, image: bundle.images.first?.image ?? "", video: false)
        }
        
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

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
        
        footerView.configurate(
            description: bundle.description,
            firstDate: bundle.firstReleaseDate ?? .now,
            lastDate: bundle.previousReleaseDate ?? .now,
            expiryDate: bundle.expiryDate ?? .now,
            series: bundle.series,
            price: bundle.price)
        return footerView
    }
}
