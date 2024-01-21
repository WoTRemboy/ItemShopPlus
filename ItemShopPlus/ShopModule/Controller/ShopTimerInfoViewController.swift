//
//  ShopTimerInfoViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

class ShopTimerInfoViewController: UIViewController {
    
    var lastUpdate: Date?
    let infoView = ShopTimerInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        view.backgroundColor = .BackColors.backElevated
                
        view.addSubview(infoView)
        setConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        infoView.timer?.invalidate()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func navigationBarSetup() {
        navigationItem.title = Texts.ShopPage.rotaionTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setConstraints() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
