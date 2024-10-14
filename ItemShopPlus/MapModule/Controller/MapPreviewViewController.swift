//
//  MapPreviewViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.02.2024.
//

import UIKit
import Kingfisher

/// A view controller responsible for displaying and managing the preview of a game map
final class MapPreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Array of all available maps fetched from the network
    private var maps = [Map]()
    /// Holds the currently selected map
    private var actualMap = Map(patchVersion: "", realeseDate: .now, clearImage: "", poiImage: "")
    
    /// URL of the current image being displayed
    private var image: String
    /// Task to handle the image loading process
    private var imageLoadTask: DownloadTask?
    /// Currently selected POI (Point of Interest) view option
    private var selectedPOI = Texts.MapPage.poi
    
    /// Network service to handle map data fetching
    private let networkService = DefaultNetworkService()
    
    // MARK: - UI Elements and Views
    
    /// Scroll view with zoom functionality for the map image
    private let scrollView = MapZoomView()
    /// View displayed when there is no internet connection
    private let noInternetView = EmptyView(type: .internet)
    /// Activity indicator to show loading status
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    /// Back button to navigate back to the main screen
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    /// Button to change between different POI (Point of Interest) views
    private let poiChangeButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .MapPage.poiMenu
        button.isEnabled = false
        return button
    }()
    
    /// Button to open the archive and select from previous map versions
    private let archiveButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .MapPage.archiveMenu
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initialization
    
    /// Initializes the controller with the image URL
    /// - Parameter image: The URL of the image to be displayed
    init(image: String) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        guard scrollView.imageView.image == nil else { return }
        getMaps()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Cancels image loading task if active
        ImageLoader.cancelImageLoad(task: imageLoadTask)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        poiMenuSetup()
        scrollViewSetup()
        noInternetSetup()
    }
    
    // MARK: - Actions
    
    /// Refreshes the current map image
    @objc private func refresh() {
        imageLoadTask = self.loadAndShowImage(from: image, to: scrollView.imageView)
    }
    
    /// Shows the currently selected map image (POI version)
    private func showActualMap() {
        imageLoadTask = self.loadAndShowImage(from: actualMap.poiImage, to: scrollView.imageView)
    }
    
    /// Opens the archive of maps, allowing the user to select a previous map version
    @objc private func archiveButtonTapped() {
        let vc = MapPickerViewController(maps: maps.reversed(), currentMap: actualMap)
        
        vc.completionHandler = { map in
            self.changeImageInPreview(
                newImage: map.poiImage,
                sectionTitle: map.poiImage, type: .version)
            
            self.actualMap = map
        }
        let navController = UINavigationController(rootViewController: vc)
        let fraction = UISheetPresentationController.Detent.custom { context in
            (self.view.frame.height * 0.5 - self.view.safeAreaInsets.bottom)
        }
        navController.sheetPresentationController?.detents = [fraction]
        present(navController, animated: true)
    }
    
    // MARK: - Networking
    
    /// Fetches map data from the network and displays the latest map
    private func getMaps() {
        activityIndicatorSetup()
        
        self.networkService.getMapItems { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
            }
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    self?.maps = newItems
                    if let actual = newItems.last {
                        self?.actualMap = actual
                    }
                    self?.archiveMenuSetup()
                    self?.showActualMap()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.loadSuccess(success: false)
                }
                print(error)
            }
        }
    }
    
    /// Loads and displays the image from the provided URL
    /// - Parameters:
    ///   - imageUrlString: URL string of the image to be displayed
    ///   - imageView: The UIImageView where the image should be loaded
    /// - Returns: A `DownloadTask` to handle image loading
    private func loadAndShowImage(from imageUrlString: String, to imageView: UIImageView) -> DownloadTask? {
        activityIndicatorSetup()
        
        return ImageLoader.loadImage(urlString: imageUrlString, size: CGSize(width: 2048, height: 2048)) { image in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
                imageView.alpha = 0.5
                
                if let image = image {
                    imageView.image = image
                    self.loadSuccess(success: true)
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                        imageView.alpha = 1.0
                    }, completion: nil)
                } else {
                    self.loadSuccess(success: false)
                }
                
            }
        }
    }
    
    // MARK: - Map Change Logic
    
    /// Changes the currently displayed map image and updates the menu state
    /// - Parameters:
    ///   - newImage: The URL of the new image to display
    ///   - sectionTitle: The section title for menu selection
    ///   - type: The type of button used for the map change (e.g., POI or without POI)
    private func changeImageInPreview(newImage: String, sectionTitle: String, type: NavigationMapButtonType) {
        guard sectionTitle != selectedPOI else { return }
        guard sectionTitle != actualMap.poiImage else { return }
        
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        image = newImage
        
        DispatchQueue.main.async {
            self.poiChangeButton.isEnabled = false
            self.archiveButton.isEnabled = false
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.scrollView.imageView.alpha = 0.0
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.imageLoadTask = self.loadAndShowImage(from: newImage, to: self.scrollView.imageView)
                
                self.scrollView.isHidden = true
                self.scrollView.zoomScale = 1
                
                if type == .location {
                    self.updateMenuState(for: sectionTitle, reload: true)
                } else {
                    self.updateMenuState(for: Texts.MapPage.poi, reload: false)
                }
            }
        }
    }
    
    // MARK: - UI Elements Behaviour during Loading
    
    /// Updates the UI based on whether the map image loading was successful or not
    /// - Parameter success: Boolean indicating if the image loading was successful
    private func loadSuccess(success: Bool) {
        if success {
            noInternetView.isHidden = true
            poiChangeButton.isEnabled = true
            archiveButton.isEnabled = true
            scrollView.isHidden = false
        } else {
            noInternetView.isHidden = false
            poiChangeButton.isEnabled = false
            archiveButton.isEnabled = false
            scrollView.isHidden = true
            scrollView.imageView.image = nil
        }
    }
    
    // MARK: - Menu Setup
    
    /// Configures the Point of Interest (POI) menu for switching between map views
    private func poiMenuSetup() {
        let poiAction = UIAction(title: Texts.MapPage.poi, image: .MapPage.poiAction) { [weak self] action in
            self?.changeImageInPreview(newImage: self?.actualMap.poiImage ?? Texts.MapPage.poi, sectionTitle: Texts.MapPage.poi, type: .location)
        }
        poiAction.state = .on
        
        let clearAction = UIAction(title: Texts.MapPage.clear, image: .MapPage.clearAction) { [weak self] action in
            self?.changeImageInPreview(newImage: self?.actualMap.clearImage ?? Texts.MapPage.clear, sectionTitle: Texts.MapPage.clear, type: .location)
        }
        poiChangeButton.menu = UIMenu(title: "", children: [poiAction, clearAction])
    }
    
    /// Configures the archive button to open the archive of maps
    private func archiveMenuSetup() {
        archiveButton.target = self
        archiveButton.action = #selector(archiveButtonTapped)
    }
    
    /// Updates the state of the POI menu and enables/disables items based on selection
    /// - Parameters:
    ///   - sectionTitle: The title of the selected section
    ///   - reload: Whether to reload the previous state
    private func updateMenuState(for sectionTitle: String, reload: Bool) {
        if let currentAction = poiChangeButton.menu?.children.first(where: { $0.title == sectionTitle }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = poiChangeButton.menu?.children.first(where: { $0.title == selectedPOI }) as? UIAction {
            if reload || selectedPOI != Texts.MapPage.poi { previousAction.state = .off }
            selectedPOI = sectionTitle
        }
    }
    
    // MARK: - UI Setups
    
    /// Configures the navigation bar for the view
    private func navigationBarSetup() {
        title = Texts.MapPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationItem.rightBarButtonItems = [
            poiChangeButton,
            archiveButton
        ]
    }
    
    /// Configures the activity indicator for loading feedback
    private func activityIndicatorSetup() {
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        noInternetView.isHidden = true
    }
    
    /// Configures the scroll view for zooming and displaying the map image
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    /// Configures the no-internet view and adds functionality to reload on tap
    private func noInternetSetup() {
        view.addSubview(noInternetView)
        noInternetView.isHidden = true
        
        noInternetView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        noInternetView.configurate()
        
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }
}
