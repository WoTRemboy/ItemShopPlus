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
    
    @objc func mapTransfer() {
        navigationController?.pushViewController(MapPreviewViewController(image: "https://media.fortniteapi.io/images/map.png?showPOI=true"), animated: true)
    }
    
    @objc func sayHi() {
        
    }

}

