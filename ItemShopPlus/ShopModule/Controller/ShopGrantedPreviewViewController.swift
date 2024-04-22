//
//  ShopGrantedPreviewViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 27.01.2024.
//

import UIKit

final class ShopGrantedPreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    private var image: String
    private var name: String
    private var size: CGSize
    private var zoom: Double
    
    // MARK: - Initialization
    
    init(image: String, name: String, size: CGSize = CGSize(width: 1024, height: 1024), zoom: Double = 2) {
        self.image = image
        self.name = name
        self.size = size
        self.zoom = zoom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .BackColors.backDefault
        navigationBarSetup()
        scrollViewSetup()
    }
    
    // MARK: - Action
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - UI Setups
    
    private func navigationBarSetup() {
        navigationItem.title = name
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func scrollViewSetup() {
        let scrollView = PreviewZoomView(image: image, presentingViewController: self, size: size, zoom: zoom)
        
        scrollView.panZoomDelegate = self
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - ShopGrantedPanZoomViewDelegate

extension ShopGrantedPreviewViewController: ShopGrantedPanZoomViewDelegate {
    func didDismiss() {
        dismiss(animated: true)
    }
}
