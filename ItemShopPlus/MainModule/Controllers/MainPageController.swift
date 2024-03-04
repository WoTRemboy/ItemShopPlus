//
//  ViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MainPageViewController: UIViewController {
    
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
    
    @objc func questsTransfer() {
        navigationController?.pushViewController(QuestsBundlePageController(), animated: true)
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
    
    @objc func mapTransfer() {
        navigationController?.pushViewController(MapPreviewViewController(image: "https://media.fortniteapi.io/images/map.png?showPOI=true"), animated: true)
    }
    
    @objc func clearCache() {
        let alertController = UIAlertController(title: nil, message: Texts.ClearCache.message, preferredStyle: .actionSheet)
        
        let cacheSize = ImageLoader.cacheSize() + VideoLoader.cacheSize()
        guard cacheSize != 0 else {
            alertControllerSetup(title: Texts.ClearCache.oops, message: Texts.ClearCache.alreadyClean)
            return
        }
            
        let clearAction = UIAlertAction(title: "\(Texts.ClearCache.cache) (\(cacheSize) \(Texts.ClearCache.megabytes))", style: .destructive) { _ in
            VideoLoader.cleanCache(entire: true) {}
            ImageLoader.cleanCache(entire: true) {
                self.alertControllerSetup(title: Texts.ClearCache.success, message: Texts.ClearCache.cleared)
            }
        }
        let cancelAction = UIAlertAction(title: Texts.ClearCache.cancel, style: .cancel)
        alertController.addAction(clearAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func alertControllerSetup(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    @objc func doNothing() {}
    
}

