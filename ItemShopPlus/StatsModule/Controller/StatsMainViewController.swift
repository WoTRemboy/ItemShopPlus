//
//  StatsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit

class StatsMainViewController: UIViewController {
    
    private let networkService = DefaultNetworkService()
    private var stats = Stats.emptyStats
    private var nickname = "WoTRemboy"
    
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .Stats.newNickname
        button.isEnabled = false
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(StatsCollectionViewCell.self, forCellWithReuseIdentifier: StatsCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard stats.name == "Error" else { return }
        getStats(nickname: nickname, isRefreshControl: false)
    }
    
    @objc private func refreshWithControl() {
        getStats(nickname: nickname, isRefreshControl: true)
    }
    
    @objc private func refreshWithoutControl() {
        getStats(nickname: nickname, isRefreshControl: false)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            
            //            let item = self.items[indexPath.item]
            //            let image = item.image
            //            let name = item.name
            //
            //            let vc = ShopGrantedPreviewViewController(image: image, name: name)
            //            let navVC = UINavigationController(rootViewController: vc)
            //            navVC.modalPresentationStyle = .fullScreen
            //            navVC.modalTransitionStyle = .crossDissolve
            //            self.present(navVC, animated: true)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func getStats(nickname: String, platform: String? = nil, isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        noInternetView.isHidden = true
        
        self.networkService.getAccountStats(nickname: nickname, platform: platform) { [weak self] result in
            DispatchQueue.main.async {
                if isRefreshControl {
                    self?.refreshControl.endRefreshing()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                }
            }
            switch result {
            case .success(let newStats):
                DispatchQueue.main.async {
                    self?.stats = newStats
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = false
                    self?.noInternetView.isHidden = true
                    self?.symbolButton.isEnabled = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.symbolButton.isEnabled = false
                }
                print(error)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.StatsPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
    }
    
    private func noInternetSetup() {
        view.addSubview(noInternetView)
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        
        noInternetView.isHidden = true
        noInternetView.configurate()
        noInternetView.reloadButton.addTarget(self, action: #selector(refreshWithoutControl), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noInternetView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWithControl), for: .valueChanged)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}


extension StatsMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatsCollectionViewCell.identifier, for: indexPath) as? StatsCollectionViewCell else {
            fatalError("Failed to dequeue StatsCollectionViewCell in StatsMainViewController")
        }
        switch indexPath.row {
        case 0:
            cell.configurate(type: .title, firstStat: Double(stats.season ?? 0), secondStat: Double(stats.level))
        case 1:
            cell.configurate(type: .global,
                             firstStat: stats.sumTopOne(),
                             secondStat: stats.averageKD(type: .global))
        case 2:
            cell.configurate(type: .input,
                             firstStat: stats.averageKD(type: .controller),
                             secondStat: stats.averageKD(type: .keyboard))
        case 3:
            cell.configurate(
                type: .history,
                firstStat: Double(stats.history.max(by: { $1.level > $0.level })?.season ?? 0),
                secondStat: Double(stats.history.max(by: { $1.level > $0.level })?.level ?? 0))
        default:
            cell.configurate(type: .title, firstStat: Double(stats.season ?? -1), secondStat: Double(stats.level))
        }
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StatsMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 32
        let legacyWidth = (view.frame.width / 3)
        let heightSize = legacyWidth + 5 + 17 + 5 + 17 + 5 /* topAnchors + fontSizes */
        return CGSize(width: widthSize, height: heightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = CGSize(width: view.frame.width, height: 40)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeaderReusableView.identifier, for: indexPath) as? CollectionHeaderReusableView else {
            fatalError("Failed to dequeue CollectionHeaderReusableView in StatsMainViewController")
        }
        headerView.configurate(with: nickname)
        return headerView
    }
}
