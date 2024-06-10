//
//  StatsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

class StatsDetailsViewController: UIViewController {
    
    private var allStats: Stats = Stats.emptyStats
    private var type: StatsSegment = .global
    private var inputKey = "keyboardmouse"
    
    private let sortOrder = ["solo", "duo", "trio", "squad"]
    private var sortedStats = [(String, SectionStats)]()
    
    private var appLanguage: String {
        if let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            if let currentLang = userDefault.string(forKey: Texts.LanguageSave.userDefaultsKey) {
                return currentLang
            }
        }
        return Texts.NetworkRequest.language
    }
    
    private let inputButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
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
        inputSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        sortingStats()
        collectionViewSetup()
    }
    
    private func sortingStats() {
        sortedStats = sortOrder.compactMap { key -> (String, SectionStats)? in
            if type == .global, let stats = allStats.global[key] {
                return (key, stats)
            } else if type == .input, let stats = allStats.input[inputKey]?.stats[key] {
                return (key, stats)
            }
            return nil
        }
    }
    
    private func defineNumberPosition(number: Int) -> String {
        switch appLanguage {
        case "tr":
            return "\(number). \(Texts.StatsDetailsCell.season)"
        default:
            return "\(Texts.StatsDetailsCell.season) \(number)"
        }
    }
    
    private func inputMemoryManager(request: InputMemoryManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: "\(Texts.StatsPage.title)\(allStats.name)") {
                inputKey = retrievedString
            } else {
                print("There is no currency data in UserDefaults")
            }
        case .save:
            UserDefaults.standard.set(inputKey, forKey: "\(Texts.StatsPage.title)\(allStats.name)")
        }
    }
    
    private func inputSetup() {
        if let inputKey = allStats.input.keys.first {
            self.inputKey = inputKey
        }
        inputMemoryManager(request: .get)
    }
    
    private func menuSetup() {
        let inputs = allStats.input.values
        
        var children = [UIAction]()
        for input in inputs.sorted(by: { $0.input < $1.input }) {
            let sectionAction = UIAction(title: SelectingMethods.selectInput(type: input.input), image: SelectingMethods.selectInput(type: input.input)) { [weak self] action in
                self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectInput(type: input.input)
                self?.updateStats(input: input.input)
            }
            children.append(sectionAction)
            input.input == inputKey ? sectionAction.state = .on : nil
        }
        inputButton.menu = UIMenu(title: "", children: children)
    }
    
    private func updateMenuState(for sectionTitle: String) {
        guard inputKey != sectionTitle else { return }
        if let currentAction = inputButton.menu?.children.first(where: { $0.title == SelectingMethods.selectInput(type: sectionTitle) }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = inputButton.menu?.children.first(where: { $0.title == SelectingMethods.selectInput(type: inputKey) }) as? UIAction {
            previousAction.state = .off
        }
        inputKey = sectionTitle
    }
    
    private func updateStats(input: String) {
        guard inputKey != input else { return }
        updateMenuState(for: input)
        inputKey = input
        sortingStats()
        inputMemoryManager(request: .save)
        UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.collectionView.reloadData()
        }, completion: nil)
    }
    
    private func navigationBarSetup() {
        navigationItem.largeTitleDisplayMode = .never
        
        guard type == .input else { return }
        inputButton.target = self
        inputButton.image = SelectingMethods.selectInput(type: inputKey)
        navigationItem.rightBarButtonItem = inputButton
        menuSetup()
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
            return allStats.input[inputKey]?.stats.count ?? 0
        case .history:
            return allStats.history.count
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
        case .global, .input:
            cell.configurate(stats: sortedStats[indexPath.section].1, history: LevelHistory.emptyHistory, type: .stats)
        case .history:
            cell.configurate(stats: SectionStats.emptyStats, history: allStats.history.reversed()[indexPath.section], type: .history)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StatsDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 32
        switch type {
        case .title:
            return CGSize(width: 0, height: 0)
        case .global, .input:
            let heightSize = CGFloat(210)
            return CGSize(width: widthSize, height: heightSize)
        case .history:
            let heightSize = CGFloat(70)
            return CGSize(width: widthSize, height: heightSize)
        }
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
        case .global, .input:
            headerView.configurate(with: SelectingMethods.selectPartyType(type: sortedStats[indexPath.section].0))
        case .history:
            headerView.configurate(with: defineNumberPosition(number: allStats.history.reversed()[indexPath.section].season))
        }
        
        return headerView
    }
}
