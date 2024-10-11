//
//  BattlePassGrantedViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit
import AVKit

/// The view controller displays detailed information about a specific Battle Pass item, including its video preview, description, and other related parameters
final class BattlePassGrantedViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The Battle Pass item displayed in this view
    private var item = BattlePassItem.emptyItem
    
    /// Stores the original navigation bar title attributes to restore later
    private var originalTitleAttributes: [NSAttributedString.Key : Any]?
    /// Flag to indicate if the video player is presented fullscreen
    private var isPresentedFullScreen = false
    
    // MARK: - UI Elements and Views
    
    /// The player view controller for displaying the item's video
    private var playerViewController = AVPlayerViewController()
    
    /// Collection view to display item details, rarity, and related parameters
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CollectionRarityCell.self, forCellWithReuseIdentifier: CollectionRarityCell.identifier)
        collectionView.register(BattlePassCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BattlePassCollectionReusableView.identifier)
        return collectionView
    }()
    
    /// Back button to return to the previous screen
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToPass
        return button
    }()
    
    // MARK: - Initialization
    
    /// Custom initializer to create the controller with a specific Battle Pass item
    /// - Parameter item: The Battle Pass item to be displayed in the view
    init(item: BattlePassItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = item.name
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
        // Updates the navigation bar title attributes
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isPresentedFullScreen {
            // Restores the original title attributes
            navigationController?.navigationBar.largeTitleTextAttributes = originalTitleAttributes
        }
    }
    
    // MARK: - Action
    
    /// Handles taps on the collection view cells and triggers animations and video playback or image previews
    /// - Parameter gestureRecognizer: The gesture recognizer detecting taps
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    /// Handles the end of video playback and dismisses the video player
    @objc private func videoDidEnd() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
        self.playerViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Rows and Cell Animation Methods
    
    /// Counts the number of rows required to display the item's attributes
    /// - Returns: The number of rows as a `Float`
    private func countRows() -> Float {
        var count: Float = 2 // payType + addedDate
        if !item.description.isEmpty { count += 1 }
        if item.series != nil { count += 1 }
        if item.set != nil { count += 1 }
        if !item.introduction.isEmpty { count += 1 }
        if item.rewardWall != 0 { count += 1 }
        if item.levelWall != 0 { count += 1 }
        if item.type == Texts.BattlePassCell.loadingScreen { count += 0.5 }
        
        return count
    }
    
    /// Animates the selection of a cell and triggers video playback or image preview
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            if let video = self.item.video, let videoURL = URL(string: video) {
                self.videoSetup(videoURL: videoURL)
            } else {
                self.previewSetup()
            }
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up and configures the video player for the item's video
    /// - Parameter videoURL: The URL of the video to be played
    private func videoSetup(videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        playerViewController.player = player
        
        self.isPresentedFullScreen = true
        self.present(playerViewController, animated: true) {
            self.playerViewController.player?.play()
            NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session:", error)
        }
    }
    
    /// Configures and presents a preview view for the item's image
    private func previewSetup() {
        self.isPresentedFullScreen = true
        
        let vc = ShopGrantedPreviewViewController(image: self.item.image, shareImage: self.item.shareImage, name: self.item.name)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        navVC.modalTransitionStyle = .crossDissolve
        self.present(navVC, animated: true)
    }
    
    /// Configures and sets up UI constraints for the `collectionView`
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

extension BattlePassGrantedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    /// Configures and returns the cell for a given index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionRarityCell.identifier, for: indexPath) as? CollectionRarityCell else {
            fatalError("Failed to dequeue ShopGrantedCollectionViewCell in ShopGrantedViewController")
        }
        cell.configurate(name: item.name, type: item.type, rarity: item.rarity, image: item.image, video: item.video != nil)
        
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BattlePassGrantedViewController: UICollectionViewDelegateFlowLayout {
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
    
    /// Configures and returns a footer view for the given section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BattlePassCollectionReusableView.identifier, for: indexPath) as? BattlePassCollectionReusableView else {
            fatalError("Failed to dequeue ShopCollectionReusableView in ShopViewController")
        }
        
        footerView.configurate(description: item.description, series: item.series, set: item.set, payType: item.payType, introduced: item.introduction, addedDate: item.releaseDate, rewardWall: item.rewardWall, levelWall: item.levelWall, price: item.price)
        return footerView
    }
}
