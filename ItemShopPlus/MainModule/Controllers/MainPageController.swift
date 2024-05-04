//
//  ViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

final class MainPageViewController: UIViewController {
    
    private let buttonController = MPButtonViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.Pages.main
        view.backgroundColor = .backDefault
        
        UIView.appearance().isExclusiveTouch = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(buttonController.view)
        
        addChild(buttonController)
        buttonController.didMove(toParent: self)
    }
    
    @objc func shopTransfer() {
        navigationController?.pushViewController(ShopViewController(), animated: true)
    }
    
    @objc func battlePassTransfer() {
        navigationController?.pushViewController(BattlePassMainViewController(), animated: true)
    }
    
    @objc func crewTransfer() {
        navigationController?.pushViewController(CrewMainViewController(), animated: true)
    }
    
    @objc func bundleTransfer() {
        navigationController?.pushViewController(BundlesMainViewController(), animated: true)
    }
    
    @objc func lootDetailsTransfer() {
        navigationController?.pushViewController(LootDetailsMainViewController(), animated: true)
    }
    
    @objc func statsTransfer() {
        navigationController?.pushViewController(StatsMainViewController(), animated: true)
    }
    
    @objc func mapTransfer() {
        navigationController?.pushViewController(MapPreviewViewController(image: "https://media.fortniteapi.io/images/map.png?showPOI=true"), animated: true)
    }
    
    @objc func settingTransfer() {
        navigationController?.pushViewController(SettingsMainViewController(), animated: true)
    }
    
    @objc func doNothing() {
        let alertController = UIAlertController(title: "Coming soon!", message: "Если кто-то сделает дезигн :(", preferredStyle: .alert)
        let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
}

