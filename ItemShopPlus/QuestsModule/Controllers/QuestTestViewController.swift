//
//  QuestTestViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.03.2024.
//

import UIKit

final class QuestTestViewController: UIViewController {
    
    private var questBundles = [QuestBundle]()
    
    private let networkService = DefaultNetworkService()
    
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        guard questBundles.isEmpty else { return }
        getBundles(isRefreshControl: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
    }
    
    private func getBundles(isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        
        self.networkService.getQuestBundles { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            }
            
            switch result {
            case .success(let newItems):
                
                print(newItems)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.Quest.title
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
