//
//  CrewFooterReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 25.02.2024.
//

import UIKit

/// A reusable view used as a footer in the Crew section of the collection view
final class CrewFooterReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    /// Identifier used to dequeue the reusable view
    static let identifier = Texts.CrewPageCell.footerIdentifier
    /// Indicates the position of the currency symbol for the displayed price
    private var symbolPosition: CurrencySymbolPosition = .left
    
    // MARK: - UI Elements and Views
    
    /// A view displaying the introduction of the crew pack
    private let introductionView = CollectionParametersRowView(
        frame: .null,
        title: Texts.CrewPageCell.introductionTitle,
        content: Texts.CrewPageCell.introductionText)
    
    /// A view displaying the main benefits of the crew pack
    private let mainBenefitsView = CollectionParametersRowView(
        frame: .null,
        title: Texts.CrewPageCell.mainBenefits,
        content: Texts.CrewPageCell.no)
    
    /// A view displaying additional benefits of the crew pack
    private let addBenefitsView = CollectionParametersRowView(
        frame: .null,
        title: Texts.CrewPageCell.additionalBenefints,
        content: Texts.CrewPageCell.no)
    
    /// A label that shows the price of the crew pack
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.price
        label.textColor = .labelPrimary
        label.font = .totalPrice()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    /// A label that shows the title for the description section
    private let descriptionTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriprion
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label that shows the description content of the crew pack
    private let descriptionContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriptionData
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// A separator line view to visually separate the description content from other rows
    private let descriptionSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    /// A label that shows the total price label text
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    /// A stack view that contains the `introductionView`, `mainBenefitsView`, and `addBenefitsView` for layout management
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Public Configure Methods
    
    /// Configures the reusable view with the provided details of the crew pack
    /// - Parameters:
    ///   - price: The price of the crew pack
    ///   - description: The description of the crew pack
    ///   - introduced: The introduction details of the crew pack
    ///   - battlePass: The battle pass details of the crew pack
    ///   - benefits: Additional benefits of the crew pack
    public func configurate(price: CrewPrice, description: String, introduced: String, battlePass: String, benefits: String) {
        changePrice(price: price, firstTime: true)
        descriptionContentLabel.text = description
        
        introductionView.configurate(content: introduced)
        addBenefitsView.configurate(content: benefits)
        mainBenefitsView.configurate(content: "\(Texts.CrewPageCell.vbucks) \(Texts.CrewPageCell.and) \(battlePass)")
        
        setupUI()
    }
    
    /// Changes the price displayed in the view
    /// - Parameters:
    ///   - price: The new price details to be displayed
    ///   - firstTime: A boolean indicating if it's the first view launch, which affects the animation
    public func changePrice(price: CrewPrice, firstTime: Bool) {
        symbolPosition = SelectingMethods.selectCurrencyPosition(type: price.type)
        let priceToShow = Int(price.price * 10) % 10 == 0 ? String(Int(price.price.rounded())) : String(price.price)
        
        // Updates the price label with a flip animation based on the currency symbol position
        switch symbolPosition {
        case .left:
            UIView.transition(with: priceLabel, duration: firstTime ? 0 : 0.3, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(price.symbol) \(priceToShow)"
            }, completion: nil)
        case .right:
            UIView.transition(with: priceLabel, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                self.priceLabel.text = "\(priceToShow) \(price.symbol)"
            }, completion: nil)
        }
    }
    
    // MARK: - UI Setups
    
    /// Configures the description section layout
    private func descriptionSetup() {
        addSubview(descriptionTitleLable)
        addSubview(descriptionContentLabel)
        addSubview(descriptionSeparatorLine)
        
        descriptionTitleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionSeparatorLine.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            descriptionSeparatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionSeparatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionTitleLable.bottomAnchor.constraint(equalTo: descriptionSeparatorLine.topAnchor, constant: 70/2 - 2),
            descriptionTitleLable.leadingAnchor.constraint(equalTo: descriptionSeparatorLine.leadingAnchor),
            descriptionTitleLable.trailingAnchor.constraint(equalTo: descriptionSeparatorLine.trailingAnchor),
            
            descriptionContentLabel.topAnchor.constraint(equalTo: descriptionTitleLable.bottomAnchor, constant: 4),
            descriptionContentLabel.leadingAnchor.constraint(equalTo: descriptionTitleLable.leadingAnchor),
            descriptionContentLabel.trailingAnchor.constraint(equalTo: descriptionTitleLable.trailingAnchor)
        ])
    }
    
    /// Configures the stack view layout
    private func stackViewSetup() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(introductionView)
        stackView.addArrangedSubview(mainBenefitsView)
        stackView.addArrangedSubview(addBenefitsView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: descriptionContentLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    /// Configures the total price section layout
    private func totalPriceSetup() {
        addSubview(totalPriceLabel)
        addSubview(priceLabel)
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    /// Configures the overall UI layout by setting up the individual sections
    private func setupUI() {
        descriptionSetup()
        stackViewSetup()
        totalPriceSetup()
        
        NSLayoutConstraint.activate([
            introductionView.heightAnchor.constraint(equalToConstant: 70),
            mainBenefitsView.heightAnchor.constraint(equalTo: introductionView.heightAnchor),
            addBenefitsView.heightAnchor.constraint(equalTo: mainBenefitsView.heightAnchor),
        ])
    }
}


