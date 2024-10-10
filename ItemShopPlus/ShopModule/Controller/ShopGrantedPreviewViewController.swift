//
//  ShopGrantedPreviewViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.01.2024.
//

import UIKit
import Kingfisher

/// A view controller responsible for displaying a full-screen preview of granted items in the shop
final class ShopGrantedPreviewViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// Button for sharing the current preview image
    private let shareButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .ShopGranted.share
        button.action = #selector(presentShareSheet)
        return button
    }()
    
    // MARK: - Properties
    
    /// URL string for the main image to be displayed in the preview
    private var image: String
    /// URL string for the image used when sharing the item
    private var shareImage: String
    /// Name of the granted item being previewed
    private var name: String
    /// Size of the preview image
    private var size: CGSize
    /// Zoom factor for the preview image
    private var zoom: Double
    
    /// Reference to the image loading task for cancellation when the view disappears
    private var imageLoadTask: DownloadTask?
    /// Network manager for handling network-related operations
    private let networkManager = DefaultNetworkService()
    
    // MARK: - Initialization
    
    init(image: String, shareImage: String = String(), name: String, size: CGSize = CGSize(width: 1024, height: 1024), zoom: Double = 2) {
        self.image = image
        self.shareImage = shareImage
        self.name = name
        self.size = size
        self.zoom = zoom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view's background color and navigation bar
        view.backgroundColor = .BackColors.backDefault
        navigationBarSetup()
        // Set up the scroll view for the image preview
        scrollViewSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Cancel any ongoing image download task to free up resources
        imageLoadTask?.cancel()
    }
    
    // MARK: - Action
    
    /// Dismisses the view controller when the cancel button is tapped
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// Presents a share sheet with the share image
    @objc private func presentShareSheet() {
        guard !shareImage.isEmpty else { return }
        var itemsToShare = [UIImage?]()
        // Load the image to be shared and present the share sheet
        imageLoadTask = ImageLoader.loadImage(urlString: shareImage, size: size) { image in
            itemsToShare.append(image)
            let shareSheetVC = UIActivityViewController(
                activityItems: itemsToShare as [Any],
                applicationActivities: nil)
            self.present(shareSheetVC, animated: true)
        }
    }
    
    // MARK: - UI Setups
    
    /// Sets up the navigation bar with the item name and action buttons
    private func navigationBarSetup() {
        navigationItem.title = name
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        // Configure the share button and add it to the navigation bar if the share image is available
        shareButton.target = self
        shareImage.isEmpty ? shareButton.isHidden = true : nil
        navigationItem.rightBarButtonItem = shareButton
    }
    
    /// Sets up a scroll view for displaying the preview image with zoom and pan capabilities
    private func scrollViewSetup() {
        // Initialize the custom zoom view for the preview image
        let scrollView = PreviewZoomView(image: image, presentingViewController: self, size: size, zoom: zoom)
        
        // Set the delegate for dismissing the view
        scrollView.panZoomDelegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - ShopGrantedPanZoomViewDelegate

// Conformance to the `ShopGrantedPanZoomViewDelegate` protocol for handling pan and zoom interactions
extension ShopGrantedPreviewViewController: ShopGrantedPanZoomViewDelegate {
    func didDismiss() {
        dismiss(animated: true)
    }
}
