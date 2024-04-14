//
//  StatsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

class StatsDetailsViewController: UIViewController {
    
    private var allStats: Stats = Stats.emptyStats
    private var statsSegment = [String: SectionStats]()
    private var history = [LevelHistory]()
    private var type: StatsSegment = .global
    
    private let sortOrder = ["solo", "duo", "trio", "squad"]
    private var sortedStats = [(String, SectionStats)]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(StatsDetailsCollectionViewCell.self, forCellWithReuseIdentifier: StatsDetailsCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String?, stats: Stats, type: StatsSegment) {
        self.init(nibName: nil, bundle: nil)
        self.title = title
        self.allStats = stats
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        sortingStats()
        collectionViewSetup()
    }
    
    private func sortingStats() {
        sortedStats = sortOrder.compactMap { key -> (String, SectionStats)? in
            if let stats = allStats.global[key] {
                return (key, stats)
            }
            return nil
        }
    }
    
    private func collectionViewSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
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


extension StatsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch type {
        case .title:
            return 0
        case .global:
            return allStats.global.count
        case .input:
            return allStats.input["gamepad"]?.stats.count ?? 0
        case .history:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatsDetailsCollectionViewCell.identifier, for: indexPath) as? StatsDetailsCollectionViewCell else {
            fatalError("Failed to dequeue StatsDetailsCollectionViewCell in StatsDetailsViewController")
        }
        switch type {
        case .title:
            return cell
        case .global:
            cell.configurate(stats: sortedStats[indexPath.section].1, history: LevelHistory.emptyHistory, type: .stats)
        case .input:
            cell.configurate(stats: sortedStats[indexPath.row].1, history: LevelHistory.emptyHistory, type: .stats)
        case .history:
            cell.configurate(stats: SectionStats.emptyStats, history: allStats.history[indexPath.row], type: .history)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StatsDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 32
        let heightSize = CGFloat(210)
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
        
        switch type {
        case .title:
            return headerView
        case .global:
            headerView.configurate(with: "\(Texts.StatsDetailsCell.mode) \(sortedStats[indexPath.section].0.capitalized)")
        case .input:
            headerView.configurate(with: sortedStats[indexPath.section].0.capitalized)
        case .history:
            headerView.configurate(with: "Levels")
        }
        
        return headerView
    }
}
