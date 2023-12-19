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
        view.backgroundColor = .backPrimary
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(buttonController.view)
        
        addChild(buttonController)
        buttonController.didMove(toParent: self)
    }
    
    @objc func sayHi() {
        navigationController?.pushViewController(QuestsBundlePageController(items: BundleMockData().createMock()), animated: true)
    }

}

