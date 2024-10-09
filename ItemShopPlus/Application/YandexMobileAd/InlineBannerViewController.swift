//
//  InlineBannerViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.05.2024.
//

import UIKit
import YandexMobileAds

/// A view controller that handles displaying inline banner ads
final class InlineBannerViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The ad view used to display banner ads
    private lazy var adView: AdView = {
        // Configure the banner ad size
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 320)
        
        // Initialize the ad view with a specific ad unit ID and ad size
        let adView = AdView(adUnitID: "R-M-8193757-1", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        // Start loading the ad
        adView.loadAd()
    }
    
    // MARK: - Helper Methods
    
    /// Displays the ad view by adding it to the view hierarchy and setting up constraints
    func showAdd() {
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            adView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - AdViewDelegate

extension InlineBannerViewController: AdViewDelegate {
    
    /// This method will call after successfully loading
    func adViewDidLoad(_ adView: AdView) {
        // Display the ad
        showAdd()
        print("YandexMobile " + #function)
    }

    /// This method will call after getting any error while loading the ad
    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        // Handle the ad loading failure
        print("YandexMobile " + #function)
    }
}
