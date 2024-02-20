//
//  MapPreviewViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.02.2024.
//

import UIKit

class MapPreviewViewController: UIViewController {
    
    private var image: String
    private var imageLoadTask: URLSessionDataTask?
    
    private let scrollView = MapZoomView()
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    init(image: String) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageLoadTask = loadAndShowImage(from: image, to: scrollView.imageView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ImageLoader.cancelImageLoad(task: imageLoadTask)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.MapPage.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .BackColors.backDefault
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        scrollViewSetup()
        
        view.addSubview(noInternetView)
        
        noInternetSetup()
    }
    
    @objc private func refresh() {
        imageLoadTask = loadAndShowImage(from: image, to: scrollView.imageView)
    }
    
    private func loadAndShowImage(from imageUrlString: String, to imageView: UIImageView) -> URLSessionDataTask? {
        
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        noInternetView.isHidden = true
        
        return ImageLoader.mapLoadImage(urlString: imageUrlString) { image in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                imageView.alpha = 0.5
                if let image = image {
                    imageView.image = image
                    self.noInternetView.isHidden = true
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                        imageView.alpha = 1.0
                    }, completion: nil)
                } else {
                    self.noInternetView.isHidden = false
                }
                
            }
        }
    }
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func noInternetSetup() {
        noInternetView.isHidden = true
        noInternetView.reloadButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        noInternetView.configurate()
        
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}

