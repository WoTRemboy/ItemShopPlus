//
//  BundlesDetailsViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 22.04.2024.
//

import UIKit

final class BundlesDetailsViewController: UIViewController {
    
    private let item: BundleItem
    private var currentSectionTitle = Texts.Currency.Code.usd
    private var selectedSectionTitle = Texts.Currency.Code.usd
    public var completionHandler: ((BundlePrice) -> Void)?
    
    private var originalTitleAttributes: [NSAttributedString.Key : Any]?
    private var isPresentedFullScreen = false
    
    private let backButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = Texts.Navigation.backToBundles
        return button
    }()
    
    private let symbolButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = .CurrencySymbol.usd
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BundlesDetailsCollectionViewCell.self, forCellWithReuseIdentifier: BundlesDetailsCollectionViewCell.identifier)
        collectionView.register(BundlesDetailsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BundlesDetailsCollectionReusableView.identifier)
        return collectionView
    }()
    
    init(item: BundleItem) {
        self.item = item
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
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.segmentTitle() ?? UIFont.systemFont(ofSize: 25)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isPresentedFullScreen {
            navigationController?.navigationBar.largeTitleTextAttributes = originalTitleAttributes
        }
        let price = item.prices.first(where: { $0.code == currentSectionTitle }) ?? BundlePrice(type: .usd, code: "", symbol: "", price: 0)
        completionHandler?(price)
    }
    
    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: location) {
            animateCellSelection(at: indexPath)
        }
    }
    
    // MARK: - Cell Animation Method
    
    private func animateCellSelection(at indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            self.isPresentedFullScreen = true
            let vc = ShopGrantedPreviewViewController(image: self.item.detailsImage, name: self.item.name, size: CGSize(width: 1200, height: 1600), zoom: 1.5)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            navVC.modalTransitionStyle = .crossDissolve
            self.present(navVC, animated: true)
            
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }

    // MARK: - UserDefaults Currency
    
    private func currencyMemoryManager(request: CurrencyManager) {
        switch request {
        case .get:
            if let retrievedString = UserDefaults.standard.string(forKey: Texts.CrewPage.currencyKey) {
                currentSectionTitle = retrievedString
            } else {
                print("There is no currency data in UserDefaults")
            }
        case .save:
            UserDefaults.standard.set(currentSectionTitle, forKey: Texts.CrewPage.currencyKey)
        case .delete:
            UserDefaults.standard.removeObject(forKey: Texts.CrewPage.currencyKey)
        }
    }
    
    // MARK: - Changing Currency Methods
    
    private func updateAll(price: BundlePrice) {
        guard selectedSectionTitle != price.code else { return }
        updateMenuState(for: price.code)
        currentSectionTitle = price.code
        currencyMemoryManager(request: .save)
        
        footerUpdate(price: price)
    }
    
    private func footerUpdate(price: BundlePrice) {
        let visibleSections = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionFooter)
        for indexPath in visibleSections {
            if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as? BundlesDetailsCollectionReusableView {
                footerView.changePrice(price: price, firstTime: false)
            }
        }
    }
    
    private func navigationBarSetup() {
        title = item.name
        
        navigationItem.largeTitleDisplayMode = .always
        originalTitleAttributes = navigationController?.navigationBar.largeTitleTextAttributes
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        symbolButton.target = self
        navigationItem.rightBarButtonItem = symbolButton
        symbolButton.image = SelectingMethods.selectCurrency(type: currentSectionTitle)
        menuSetup()
    }
    
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
        let textWidth = view.frame.width - 32
        let textHeight = heightForText(item.descriptionLong, width: textWidth, font: .subhead() ?? .systemFont(ofSize: 15))
        let dateHeight = CGFloat(item.expiryDate != nil ? 70 : 0)
        
        let height: CGFloat = CGFloat(dateHeight + textHeight + 150 + 30) // date + about + total + spacer
        let size = CGSize(width: view.frame.width, height: height)
        return size
    }
    
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
