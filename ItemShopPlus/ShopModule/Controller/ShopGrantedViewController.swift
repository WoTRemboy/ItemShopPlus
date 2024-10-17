//
//  ShopGrantedViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.01.2024.
//

import UIKit
import OSLog
import AVKit

/// A log object to organize messages
private let logger = Logger(subsystem: "ShopModule", category: "GrantedController")

/// A view controller to display the granted items of a shop bundle with options to preview and watch videos of individual items
final class ShopGrantedViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Array of granted items in the bundle
    private var items = [GrantedItem?]()
    /// Count of granted items that don't have associated images
    private var itemsWithoutImages = 0
    /// The bundle item being displayed
    private let bundle: ShopItem
    
    /// Holds the original title attributes to restore when navigating back
    private var originalTitleAttributes: [NSAttributedString.Key : Any]?
    /// Boolean flag to check if the image view is presented in full screen
    private var isPresentedFullScreen = false
    /// Network service instance for fetching videos and other item data
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    /// AVPlayerViewController instance for displaying video previews
    private var playerViewController = AVPlayerViewController()
    /// Activity indicator to show loading state
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    /// Collection view displaying granted items and bundle information
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionRarityCell.self, forCellWithReuseIdentifier: CollectionRarityCell.identifier)
        collectionView.register(ShopGrantedCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ShopGrantedCollectionReusableView.identifier)
        return collectionView
    }()
    
    /// Back button item in the navigation bar
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
        itemsWithoutImages = items.filter { $0?.image == String() }.count
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
        
        // Configure navigation item and UI elements
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
        // Set title font for navigation bar
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isPresentedFullScreen {
            navigationController?.navigationBar.largeTitleTextAttributes = originalTitleAttributes
        }
    }
    
    deinit {
        // Remove observers when deinitializing the view controller
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action
    
    /// Handles tap gestures on the collection view to present previews or videos of items
    /// - Parameter gestureRecognizer: The gesture recognizer triggering the action
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Replays the video when it reaches the end
    @objc private func videoToRepeat() {
        self.playerViewController.player?.seek(to: .zero, completionHandler: { _ in
            self.playerViewController.player?.play()
        })
    }
    
    /// Dismisses the video player when the video finishes playing
    @objc private func videoToDismiss() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        self.playerViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Rows and Cell Animation Methods
    
    /// Calculates the number of rows to display in the footer section based on the bundle metadata
    /// - Returns: The number of rows for displaying details such as first and last release dates, description, and price
    private func countRows() -> Int {
        var count = 3 // Includes first, last, and expiry dates
        if !bundle.description.isEmpty { count += 1 }
        if bundle.series != nil { count += 1 }
        
        return count
    }
    
    /// Animates the selection of a cell and determines whether to show a video or a static preview
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            if self.items.count > 0, self.itemsWithoutImages != self.items.count {
                // Check if the selected item has a video URL
                if let video = self.items[indexPath.item]?.video, let videoURL = URL(string: video) {
                    self.videoSetup(videoURL: videoURL, repeatable: false)
                } else  {
                    // Handle cases where the item is of type "outfit" or has no video
                    let item = self.items[indexPath.item]
                    if item?.typeID == "outfit" {
                        self.getVideo(index: indexPath.item)
                    } else {
                        if item?.image != String() {
                            self.previewSetup(index: indexPath.item)
                        }
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
    
    /// Fetches a video for the specified index and presents the video player if available
    /// - Parameter index: The index of the granted item in the `items` array
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
                logger.info("Shop granted items loading success")
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.previewSetup(index: index)
                }
                logger.error("Shop granted items loading error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up and presents the video player with the specified URL
    /// - Parameters:
    ///   - videoURL: The URL of the video to play
    ///   - repeatable: Boolean value indicating whether the video should repeat upon completion
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
            logger.info("Audio session set up")
        } catch {
            logger.error("Error setting audio session: \(error)")
        }
    }
    
    /// Sets up and presents the item preview view controller with the specified item image and information
    /// - Parameter index: The index of the granted item to display in the preview
    private func previewSetup(index: Int) {
        var itemImage = bundle.images.first?.image ?? String()
        var shareImage = itemImage
        var itemName = bundle.name
        if !items.isEmpty, itemsWithoutImages != items.count {
            let item = items[index]
            itemImage = item?.image ?? String()
            shareImage = item?.shareImage ?? String()
            itemName = item?.name ?? String()
        }
        self.isPresentedFullScreen = true
        
        let vc = ShopGrantedPreviewViewController(image: itemImage, shareImage: shareImage, name: itemName)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        self.present(navVC, animated: true)
    }
    
    /// Sets up the initial UI layout for the collection view
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
        return (items.count != 0 && itemsWithoutImages != items.count) ? items.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionRarityCell.identifier, for: indexPath) as? CollectionRarityCell else {
            fatalError("Failed to dequeue ShopGrantedCollectionViewCell in ShopGrantedViewController")
        }
        
        // Configure the cell based on whether granted items are present and contain images
        if items.count > 0, itemsWithoutImages != items.count, let item = items[indexPath.item] {
            cell.configurate(name: item.name, type: item.type, rarity: item.rarity ?? .common, image: item.image, video: item.video != nil || item.typeID == "outfit")
        } else {
            cell.configurate(name: bundle.name, type: bundle.type, rarity: bundle.rarity, image: bundle.images.first?.image ?? "", video: false)
        }
        
        // Add gesture recognizer for handling cell taps
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
        
        // Configure the footer view with bundle details such as description, release dates, series, and price
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
