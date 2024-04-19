//
//  BundlesMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.04.2024.
//

import UIKit

class BundlesMainViewController: UIViewController {
    
    private let networkService = DefaultNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getShop()
    }
    
    private func getShop() {
        self.networkService.getBundles { [weak self] result in
            switch result {
            case .success(let newItems):
                print(newItems)
            case .failure(let error):
                print(error)
            }
        }
    }
}
