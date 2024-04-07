//
//  StatsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit

class StatsMainViewController: UIViewController {
    
    private let networkService = DefaultNetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStats(nickname: "WoTRemboy")
    }
    
    private func getStats(nickname: String, platform: String? = nil) {
        self.networkService.getAccountStats(nickname: nickname, platform: platform) { [weak self] result in
            switch result {
            case .success(let newStats):
                print(newStats)
            case .failure(let error):
                print(error)
            }
        }
    }

}
