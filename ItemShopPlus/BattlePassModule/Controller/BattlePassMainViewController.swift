//
//  BattlePassMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 01.03.2024.
//

import UIKit

class BattlePassMainViewController: UIViewController {
    
    private var battlePass = BattlePass.emptyPass
    private var items = [BattlePassItem]()
    
    private let networkService = DefaultNetworkService()
    
    override func viewWillAppear(_ animated: Bool) {
        getBattlePass()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
    }
    
    private func getBattlePass() {
        self.networkService.getBattlePassItems { [weak self] result in
            switch result {
            case .success(let newPass):
                DispatchQueue.main.async {
                    self?.battlePass = newPass
                    print(newPass)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
