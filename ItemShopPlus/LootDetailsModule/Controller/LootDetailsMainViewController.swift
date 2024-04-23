//
//  LootDetailsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.04.2024.
//

import UIKit

class LootDetailsMainViewController: UIViewController {
    
    private let networkService = DefaultNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        getItems()
    }
    
    private func getItems() {
        self.networkService.getLootDetails { [weak self] result in
            switch result {
            case .success(let newItems):
                DispatchQueue.main.async {
                    print(newItems.count)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
