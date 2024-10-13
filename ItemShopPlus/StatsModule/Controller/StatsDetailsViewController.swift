//
//  StatsDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 14.04.2024.
//

import UIKit

/// A view controller that displays detailed statistics based on the segment (global, input, history)
final class StatsDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Holds all the stats for the user
    private var allStats: Stats = Stats.emptyStats
    /// Determines which stats segment (global, input, history) to display
    private var type: StatsSegment = .global
    /// The key to identify the current input device (e.g., keyboard, gamepad, touch)
    private var inputKey = "keyboardmouse"
    
    /// Defines the order in which stats are displayed (e.g., solo, duo, trio, squad)
    private let sortOrder = ["solo", "duo", "trio", "squad"]
    /// Stores the sorted stats based on the selected segment
    private var sortedStats = [(String, SectionStats)]()
    
    /// Retrieves the current app language from UserDefaults
    private var appLanguage: String {
        if let userDefault = UserDefaults(suiteName: "group.notificationlocalized") {
            if let currentLang = userDefault.string(forKey: Texts.LanguageSave.userDefaultsKey) {
                return currentLang
            }
        }
        return Texts.NetworkRequest.language
    }
    
    // MARK: - UI Elements
    
    /// A button for selecting the input device type
    private let inputButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
    /// The collection view that displays the stats in a list format
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(StatsDetailsCollectionViewCell.self, forCellWithReuseIdentifier: StatsDetailsCollectionViewCell.identifier)
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeaderReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializer for setting the view controller title, stats data, and segment type
    /// - Parameters:
    ///   - title: The title of the view controller
    ///   - stats: The stats object containing detailed data
    ///   - type: The segment type (global, input, history) to display
    convenience init(title: String?, stats: Stats, type: StatsSegment) {
        self.init(nibName: nil, bundle: nil)
        self.title = title
        self.allStats = stats
        self.type = type
        inputSetup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        navigationBarSetup()
        sortingStats()
        collectionViewSetup()
    }
    
    // MARK: - Sorting and Data Handling
    
    /// Sorts the stats data based on the selected segment and the predefined sort order
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
    
    /// Adjusts the number position format for different languages
    /// - Parameter number: The number to format
    /// - Returns: A formatted string with the correct placement of the number
    private func defineNumberPosition(number: Int) -> String {
        switch appLanguage {
        case "tr":
            return "\(number). \(Texts.StatsDetailsCell.season)"
        default:
            return "\(Texts.StatsDetailsCell.season) \(number)"
        }
    }
    
    /// Manages the saving and retrieving of the selected input device key using UserDefaults
    /// - Parameter request: The action (get or save) to perform on UserDefaults
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
    
    /// Sets up the initial input key for the input stats segment
    private func inputSetup() {
        if let inputKey = allStats.input.keys.first {
            self.inputKey = inputKey
        }
        inputMemoryManager(request: .get)
    }
    
    // MARK: - Menu Setup
    
    /// Sets up the menu for selecting input device types in the navigation bar
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
    
    /// Updates the menu state when a different input device is selected
    /// - Parameter sectionTitle: The selected input device key
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
    
    /// Updates the displayed stats when a new input device is selected
    /// - Parameter input: The new input device key
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
    
    // MARK: - UI Setup
    
    /// Configures the navigation bar based on the selected segment
    private func navigationBarSetup() {
        navigationItem.largeTitleDisplayMode = .never
        
        guard type == .input else { return }
        inputButton.target = self
        inputButton.image = SelectingMethods.selectInput(type: inputKey)
        navigationItem.rightBarButtonItem = inputButton
        menuSetup()
    }
    
    /// Sets up the collection view and its layout constraints
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

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension StatsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Number of cells depending on stats type
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
        // Cell to display depending on stats type
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
        // Cell height depending on stats type
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
        
        // Header view content depending on stats type
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
