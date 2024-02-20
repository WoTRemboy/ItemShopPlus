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
    private var selectedSectionTitle = Texts.MapPage.poi
    
    private let clearMap = "https://media.fortniteapi.io/images/map.png"
    private let poiMap = "https://media.fortniteapi.io/images/map.png?showPOI=true"
    
    private let scrollView = MapZoomView()
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let poiChangeButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .MapPage.poi
        button.isEnabled = false
        return button
    }()
    
    private let archiveButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .MapPage.archive
        button.isEnabled = false
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
        guard scrollView.imageView.image == nil else { return }
        imageLoadTask = loadAndShowImage(from: image, to: scrollView.imageView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        ImageLoader.removeAllCache()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        view.addSubview(noInternetView)
        
        navigationBarSetup()
        menuSetup()
        scrollViewSetup()
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
                    self.poiChangeButton.isEnabled = true
                    self.scrollView.isHidden = false
                    
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                        imageView.alpha = 1.0
                    }, completion: nil)
                } else {
                    self.noInternetView.isHidden = false
                    self.poiChangeButton.isEnabled = false
                    self.scrollView.isHidden = true
                }
                
            }
        }
    }
    
    private func changeImageInPreview(newImage: String, sectionTitle: String) {
        guard sectionTitle != selectedSectionTitle else { return }
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        image = newImage
        
        DispatchQueue.main.async {
            self.poiChangeButton.isEnabled = false
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.scrollView.imageView.alpha = 0
            }, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.scrollView.isHidden = true
                self.imageLoadTask = self.loadAndShowImage(from: newImage, to: self.scrollView.imageView)
                self.scrollView.zoomScale = 1
                self.updateMenuState(for: sectionTitle)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.MapPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        navigationItem.rightBarButtonItems = [
            poiChangeButton,
            archiveButton
        ]
    }
    
    private func menuSetup() {
        let poiAction = UIAction(title: Texts.MapPage.poi, image: UIImage(systemName: "mappin")) { [weak self] action in
            self?.changeImageInPreview(newImage: "https://media.fortniteapi.io/images/map.png?showPOI=true", sectionTitle: Texts.MapPage.poi)
        }
        poiAction.state = .on
        
        let clearAction = UIAction(title: Texts.MapPage.clear, image: UIImage(systemName: "mappin.slash")) { [weak self] action in
            self?.changeImageInPreview(newImage: "https://media.fortniteapi.io/images/map.png", sectionTitle: Texts.MapPage.clear)
        }
        poiChangeButton.menu = UIMenu(title: "", children: [poiAction, clearAction])
    }
    
    private func updateMenuState(for sectionTitle: String) {
        if let currentAction = poiChangeButton.menu?.children.first(where: { $0.title == sectionTitle }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = poiChangeButton.menu?.children.first(where: { $0.title == selectedSectionTitle }) as? UIAction {
            previousAction.state = .off
        }
        selectedSectionTitle = sectionTitle
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

