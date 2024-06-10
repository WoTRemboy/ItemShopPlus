//
//  InlineBannerViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.05.2024.
//

import UIKit
import YandexMobileAds

final class InlineBannerViewController: UIViewController {
    private lazy var adView: AdView = {
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 320)

        let adView = AdView(adUnitID: "R-M-8193757-1", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
    }()
    
    override func viewDidLoad() {
        adView.loadAd()
    }
    
    func showAdd() {
        view.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            adView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension InlineBannerViewController: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        // This method will call after successfully loading
        showAdd()
        print("YandexMobile " + #function)
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        // This method will call after getting any error while loading the ad
        print("YandexMobile " + #function)
    }
}
