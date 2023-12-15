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
        title = Texts.MainPage.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .backPrimary
        
        view.addSubview(buttonController.view)
        
        addChild(buttonController)
        buttonController.didMove(toParent: self)
    }
    
    @objc func sayHi() {
        print("Hi")
    }

}

