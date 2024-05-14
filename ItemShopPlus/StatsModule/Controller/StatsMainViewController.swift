//
//  StatsMainViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.04.2024.
//

import UIKit

final class StatsMainViewController: UIViewController {
    
    private let networkService = DefaultNetworkService()
    private var stats = Stats.emptyStats
    private var nickname = String()
    private var platform: String? = nil
    
    private let noInternetView = NoInternetView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToMain
        return button
    }()
    
    private let nicknameButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .Stats.newNickname
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
    
    private let noStatsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .Stats.noStats
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.StatsPage.nicknameKey) {
            nickname = retrievedString
        } else {
            print("There is no currency data in UserDefaults")
        }
        
        navigationBarSetup()
        collectionViewSetup()
        noInternetSetup()
        noStatsImageViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard stats.name == Texts.StatsPage.placeholder else { return }
        if nickname.isEmpty {
            showNicknamePopup(firstAppear: true)
        } else {
            getStats(nickname: nickname, platform: platform, isRefreshControl: false)
        }
    }
    
    @objc private func refreshWithControl() {
        getStats(nickname: nickname, platform: platform, isRefreshControl: true)
    }
    
    @objc private func refreshWithoutControl() {
        getStats(nickname: nickname, platform: platform, isRefreshControl: false)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    @objc private func showNicknamePopup(firstAppear: Bool) {
        let nicknameVC = NicknamePopupViewController()
        nicknameVC.completionHandler = { [weak self] newNickname, platform in
            guard let collectionView = self?.collectionView, newNickname != self?.nickname else { return }
            UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                collectionView.isHidden = true
            }, completion: nil)
            self?.getStats(nickname: newNickname, platform: platform, isRefreshControl: false)
            UIView.appearance().isExclusiveTouch = true
        }
        if firstAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.noStatsImageView.isHidden = false
            }
        }
        nicknameVC.appear(sender: self, firstAppear: firstAppear)
    }
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? StatsCollectionViewCell, indexPath.row != 0 else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            var vc: UIViewController = .init()
            switch indexPath.row {
            case 1:
                vc = StatsDetailsViewController(title: cell.getTitleText(), stats: self.stats, type: .global)
            case 2:
                vc = StatsDetailsViewController(title: cell.getTitleText(), stats: self.stats, type: .input)
            default:
                vc = StatsDetailsViewController(title: cell.getTitleText(), stats: self.stats, type: .history)
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func getStats(nickname: String, platform: String?, isRefreshControl: Bool) {
        if isRefreshControl {
            self.refreshControl.beginRefreshing()
        } else {
            self.activityIndicator.center = self.view.center
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
        noInternetView.isHidden = true
        noStatsImageView.isHidden = true
        nicknameButton.isEnabled = false
        
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
                    guard newStats.result else {
                        self?.noResultDisplay(message: newStats.resultMessage)
                        return
                    }
                    self?.stats = newStats
                    self?.nickname = newStats.name
                    
                    guard let collectionView = self?.collectionView else { return }
                    collectionView.isHidden = false
                    if isRefreshControl {
                        collectionView.reloadData()
                    } else {
                        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            collectionView.reloadData()
                        }, completion: nil)
                    }
                    self?.noInternetView.isHidden = true
                    self?.noStatsImageView.isHidden = true
                    self?.nicknameButton.isEnabled = true
                    UserDefaults.standard.set(newStats.name, forKey: Texts.StatsPage.nicknameKey)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.collectionView.isHidden = true
                    self?.noInternetView.isHidden = false
                    self?.nicknameButton.isEnabled = false
                }
                print(error)
            }
        }
    }
    
    private func noResultDisplay(message: String?) {
        dismiss(animated: false) {
            let alertController = UIAlertController(title: Texts.NicknamePopup.noResult, message: message ?? String(), preferredStyle: .alert)
            let okAction = UIAlertAction(title: Texts.ClearCache.ok, style: .default) { _ in
                self.showNicknamePopup(firstAppear: false)
                self.nicknameButton.isEnabled = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.noStatsImageView.isHidden = false
                }
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
    }
    
    private func navigationBarSetup() {
        title = Texts.StatsPage.title
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        nicknameButton.target = self
        nicknameButton.action = #selector(showNicknamePopup)
        navigationItem.rightBarButtonItem = nicknameButton
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
    
    private func noStatsImageViewSetup() {
        view.addSubview(noStatsImageView)
        noStatsImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noStatsImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noStatsImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noStatsImageView.heightAnchor.constraint(equalToConstant: 100),
            noStatsImageView.widthAnchor.constraint(equalTo: noStatsImageView.heightAnchor)
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
