//
//  BundlesDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "BundlesModule", category: "DetailsController")

/// A view controller that handles the display of detailed information about a specific bundle
final class BundlesDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The bundle item whose details are displayed in the view controller
    private let item: BundleItem
    /// A boolean indicating whether the view controller was opened from the main page
    private let fromMainPage: Bool
    /// The current selected currency section title (e.g., USD, EUR)
    private var currentSectionTitle = Texts.Currency.Code.usd
    /// The previously selected currency section title
    private var selectedSectionTitle = Texts.Currency.Code.usd
    /// A closure that handles updating the price in the main page
    public var completionHandler: ((BundlePrice) -> Void)?
    
    /// Stores the original title attributes of the navigation bar to reset after view disappears
    private var originalTitleAttributes: [NSAttributedString.Key : Any]?
    /// A boolean indicating whether the view is currently presented in full screen mode
    private var isPresentedFullScreen = false
    
    // MARK: - UI Elements
    
    /// A back button for navigating back to the previous screen
    private let backButton = UIBarButtonItem()
    
    /// A button for selecting the currency symbol
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .CurrencySymbol.usd
        return button
    }()
    
    /// A collection view for displaying the bundle details, including images and price information
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BundlesDetailsCollectionViewCell.self, forCellWithReuseIdentifier: BundlesDetailsCollectionViewCell.identifier)
        collectionView.register(BundlesDetailsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BundlesDetailsCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view controller with the given bundle item and a flag indicating if it was opened from the main page
    /// - Parameters:
    ///   - item: The `BundleItem` to display
    ///   - fromMainPage: A boolean indicating if the view controller was opened from the main page
    init(item: BundleItem, fromMainPage: Bool) {
        self.item = item
        self.fromMainPage = fromMainPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backDefault
        
        currencyMemoryManager(request: .get)
        selectedSectionTitle = currentSectionTitle
        
        navigationBarSetup()
        collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isPresentedFullScreen = false
        // Adjusts title attributes
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Resets title attributes and passes the selected price back
        if !isPresentedFullScreen {
            navigationController?.navigationBar.largeTitleTextAttributes = originalTitleAttributes
        }
        let price = item.prices.first(where: { $0.code == currentSectionTitle }) ?? BundlePrice(type: .usd, code: "", symbol: "", price: 0)
        completionHandler?(price)
    }
    
    // MARK: - Actions
    
    /// Handles the tap gesture on the collection view, triggering the animation of cell selection
    /// - Parameter gestureRecognizer: The tap gesture recognizer object
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    // MARK: - Cell Animation Method
    
    /// Animates the selection of a cell in the collection view, briefly scaling it before presenting the item in full screen
    /// - Parameter indexPath: The index path of the selected cell
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            self.isPresentedFullScreen = true
            let vc = ShopGrantedPreviewViewController(image: self.item.detailsImage, shareImage: self.item.detailsImage, name: self.item.name, size: CGSize(width: 1200, height: 1600), zoom: 1.5)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }

    // MARK: - Currency Management
    
    /// Manages the retrieval, saving, and deletion of currency data in `UserDefaults`
    /// - Parameter request: The type of action to perform (get, save, delete)
    private func currencyMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
                currentSectionTitle = retrievedString
                logger.info("Currency data retrieved from UserDefaults: \(retrievedString)")
            } else {
                logger.info("There is no currency data in UserDefaults")
            }
        case .save:
            UserDefaults.standard.set(currentSectionTitle, forKey: Texts.CrewPage.currencyKey)
            logger.info("New currency data saved to UserDefaults")
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.CrewPage.currencyKey)
        }
    }
    
    /// Updates the bundle prices with the selected currency and reloads the data
    /// - Parameters:
    ///   - price: The new `BundlePrice` to apply
    private func updateAll(price: BundlePrice) {
        guard selectedSectionTitle != price.code else { return }
        updateMenuState(for: price.code)
        currentSectionTitle = price.code
        currencyMemoryManager(request: .save)
        
        footerUpdate(price: price)
    }
    
    /// Updates the price displayed in the footer based on the selected currency
    /// - Parameter price: The `BundlePrice` to apply
    private func footerUpdate(price: BundlePrice) {
        let visibleSections = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter)
        for indexPath in visibleSections {
            if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? BundlesDetailsCollectionReusableView {
                footerView.changePrice(price: price, firstTime: false)
            }
        }
    }
    
    // MARK: - Navigation Bar Setup
    
    /// Sets up the navigation bar, configuring the title, back button, and currency selection button
    private func navigationBarSetup() {
        title = item.name
        
        navigationItem.largeTitleDisplayMode = .always
        originalTitleAttributes = navigationController?.navigationBar.largeTitleTextAttributes
        backButton.title = fromMainPage ? Texts.Navigation.backToMain : Texts.Navigation.backToBundles
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
        symbolButton.image = SelectingMethods.selectCurrency(type: currentSectionTitle)
        menuSetup()
    }
    
    // MARK: - Menu Setup
    
    /// Configures the menu for currency selection
    private func menuSetup() {
        let prices = item.prices.filter( {
            SelectingMethods.selectCurrency(type: $0.code) != UIImage()
        } )
        
        var children = [UIAction]()
        for price in prices.sorted(by: { $0.code < $1.code }) {
            let sectionAction = UIAction(title: price.code, image: SelectingMethods.selectCurrency(type: price.code)) { [weak self] action in
                self?.navigationItem.rightBarButtonItem?.image = SelectingMethods.selectCurrency(type: price.code)
                self?.updateAll(price: price)
            }
            children.append(sectionAction)
            price.code == currentSectionTitle ? sectionAction.state = .on : nil
        }
        let curPrice = prices.first(where: { $0.code == currentSectionTitle }) ?? BundlePrice.emptyPrice
        symbolButton.menu = UIMenu(title: "", children: children)
        footerUpdate(price: curPrice)
    }
    
    /// Updates the state of the menu to reflect the current selected currency
    /// - Parameter sectionTitle: The title of the currently selected section
    private func updateMenuState(for sectionTitle: String) {
        guard selectedSectionTitle != sectionTitle else { return }
        if let currentAction = symbolButton.menu?.children.first(where: { $0.title == sectionTitle }) as? UIAction {
            currentAction.state = .on
        }
        if let previousAction = symbolButton.menu?.children.first(where: { $0.title == selectedSectionTitle }) as? UIAction {
            previousAction.state = .off
        }
        selectedSectionTitle = sectionTitle
    }
    
    // MARK: - UI Setup
    
    /// Configures the collection view for displaying bundle details
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

// MARK: - UICollectionViewDelegate and UICollectionViewDataSource

extension BundlesDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BundlesDetailsCollectionViewCell.identifier, for: indexPath) as? BundlesDetailsCollectionViewCell else {
            fatalError("Failed to dequeue BundlesDetailsCollectionViewCell in BundlesDetailsViewController")
        }
        cell.configurate(image: item.detailsImage)
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        cell.addGestureRecognizer(pressGesture)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BundlesDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = view.frame.width - 32
        let heightSize = UIScreen.main.bounds.height / 3
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BundlesDetailsCollectionReusableView.identifier, for: indexPath) as? BundlesDetailsCollectionReusableView else {
            fatalError("Failed to dequeue BundlesDetailsCollectionReusableView in BundlesDetailsViewController")
        }
        let price = item.prices.first(where: { $0.code == currentSectionTitle }) ?? BundlePrice(type: .usd, code: "", symbol: "", price: 0)
            footerView.configurate(price: price, description: item.description, about: item.descriptionLong, expireDate: item.expiryDate)
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Specifies the size of the footer for each section
        let textWidth = view.frame.width - 32
        let textHeight = heightForText(item.descriptionLong, width: textWidth, font: .subhead() ?? .systemFont(ofSize: 15))
        let dateHeight = CGFloat(item.expiryDate != nil ? 70 : 0)
        
        let height: CGFloat = CGFloat(dateHeight + textHeight + 150 + 30) // date + about + total + spacer
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
    
    /// Calculates the height of text based on its content, width, and font
    /// - Parameters:
    ///   - text: The string of text whose height needs to be calculated
    ///   - width: The width within which the text is constrained
    ///   - font: The font used to render the text
    /// - Returns: The calculated height of the text, accounting for line breaks and font leading
    private func heightForText(_ text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingRect = NSString(string: text).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil)
        return ceil(boundingRect.height)
    }
}
