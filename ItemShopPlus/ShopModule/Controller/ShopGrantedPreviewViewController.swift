//
//  ShopGrantedPreviewViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.01.2024.
//

import UIKit

class ShopGrantedPreviewViewController: UIViewController {
    
    private let image: String
    private let name: String
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BackColors.backDefault
        navigationBarSetup()
        imageViewSetup()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func navigationBarSetup() {
        navigationItem.title = name
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func imageViewSetup() {
        let imageView = ShopGrantedView(frame: .null, image: image)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

}
