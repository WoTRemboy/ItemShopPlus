//
//  FavouritesItemsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.06.2024.
//

import UIKit

class FavouritesItemsViewController: UIViewController {
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
    }
    
    private func navigationBarSetup() {
        title = Texts.FavouritesPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}
