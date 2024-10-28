//
//  ShopGrantedCollectionReusableView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 24.01.2024.
//

import UIKit

/// A reusable view used in collection views to display additional details about granted items, such as price, release dates, and description
final class ShopGrantedCollectionReusableView: UICollectionReusableView {
    
    /// The reuse identifier for this view
    static let identifier = Texts.ShopGrantedCell.footerIdentifier
    
    // MARK: - UI Elements and Views
    
    /// A view displaying the series information
    private let seriesView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.series, content: Texts.ShopGrantedParameters.seriesData)
    /// A view displaying the first release date
    private let firstTimeView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.firstTime, content: Texts.ShopGrantedParameters.firstTimeData)
    /// A view displaying the last release date
    private let lastTimeView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.lastTime, content: Texts.ShopGrantedParameters.lastTimeData)
    /// A view displaying the expiry date
    private let expiryDateView = CollectionParametersRowView(frame: .null, title: Texts.ShopGrantedParameters.expiryDate, content: Texts.ShopGrantedParameters.expiryDateData)
    /// A view displaying the total price of the item
    private let priceView = CollectionTotalPriceView(frame: .null, price: Texts.ShopGrantedCell.price)
    
    /// A stack view for arranging the `CollectionParametersRowView` elements vertically
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    /// A label for displaying the description title
    private let descriptionTitleLable: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriprion
        label.textColor = .labelPrimary
        label.font = .headline()
        label.numberOfLines = 1
        return label
    }()
    
    /// A label for displaying the description content
    private let descriptionContentLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedParameters.descriptionData
        label.textColor = .labelSecondary
        label.font = .subhead()
        label.numberOfLines = 0
        return label
    }()
    
    /// A separator line view used for separating the description section
    private let descriptionSeparatorLine: UIView = {
        let line = UIView()
        line.backgroundColor = .labelDisable
        return line
    }()
    
    /// A label for displaying the total price information
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.ShopGrantedCell.total
        label.textColor = .labelSecondary
        label.font = .footnote()
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Public Configure Method
    
    /// Configures the view with the provided information
    /// - Parameters:
    ///   - description: The description text for the shop items
    ///   - firstDate: The first release date of the item
    ///   - lastDate: The last release date of the item
    ///   - expiryDate: The expiry date of the item
    ///   - series: The series information for the item
    ///   - price: The total price of the item
    public func configurate(description: String, firstDate: Date, lastDate: Date, expiryDate: Date, series: String?, price: Int) {
        // Set the description content
        descriptionContentLabel.text = description
        // Set the series view content
        seriesView.configurate(content: series ?? "")
        // Set the price view content
        priceView.configurate(price: String(price), currency: .vbucks)
        
        // Set the date values for the first, last, and expiry date views
        firstTimeView.configurate(content: DateFormating.dateFormatterDefault(date: firstDate))
        lastTimeView.configurate(content: DateFormating.dateFormatterDefault(date: lastDate))
        expiryDateView.configurate(content: DateFormating.dateFormatterDefault(date: expiryDate))

        // Set up the UI layout based on the given parameters
        setupUI(isSeries: series != nil, isDescription: !description.isEmpty, price: String(price))
    }
    
    // MARK: - UI Setups
    
    /// Sets up the UI layout and constraints based on the provided parameters
    /// - Parameters:
    ///   - isSeries: A Boolean value indicating if the series view should be displayed
    ///   - isDescription: A Boolean value indicating if the description view should be displayed
    ///   - price: The price of the shop item
    private func setupUI(isSeries: Bool, isDescription: Bool, price: String) {
        // Configure the description section if applicable
        isDescription ? descriptionSetup() : nil
        // Add series view if a series is provided
        isSeries ? stackView.addArrangedSubview(seriesView) : nil
        
        stackView.addArrangedSubview(firstTimeView)
        stackView.addArrangedSubview(lastTimeView)
        stackView.addArrangedSubview(expiryDateView)
        
        // Set up stack view and subviews layout
        stackViewSetup(isDescription: isDescription)
        subStackSetup(isSeries: isSeries)
        priceSetup(price: price)
    }
    
    /// Sets up the layout and constraints for the stack view
    /// - Parameter isDescription: A Boolean value indicating if the description view should be displayed
    private func stackViewSetup(isDescription: Bool) {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: isDescription ? descriptionContentLabel.bottomAnchor : topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    /// Sets up the layout and constraints for the subviews inside the stack view
    /// - Parameter isSeries: A Boolean value indicating if the series view should be displayed
    private func subStackSetup(isSeries: Bool) {
        NSLayoutConstraint.activate([
            firstTimeView.heightAnchor.constraint(equalToConstant: 70),
            lastTimeView.heightAnchor.constraint(equalToConstant: 70),
            expiryDateView.heightAnchor.constraint(equalToConstant: 70)
        ])
        isSeries ? seriesView.heightAnchor.constraint(equalToConstant: 70).isActive = true : nil
    }
    
    /// Sets up the layout and constraints for the description section
    private func descriptionSetup() {
        addSubview(descriptionSeparatorLine)
        addSubview(descriptionTitleLable)
        addSubview(descriptionContentLabel)
        
        descriptionSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        descriptionTitleLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Set up descriptionSeparatorLine constraints
            descriptionSeparatorLine.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            descriptionSeparatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionSeparatorLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            descriptionSeparatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Set up descriptionTitleLable constraints
            descriptionTitleLable.bottomAnchor.constraint(equalTo: descriptionSeparatorLine.topAnchor, constant: 70/2 - 2),
            descriptionTitleLable.leadingAnchor.constraint(equalTo: descriptionSeparatorLine.leadingAnchor),
            descriptionTitleLable.trailingAnchor.constraint(equalTo: descriptionSeparatorLine.trailingAnchor),
            
            // Set up descriptionContentLabel constraints
            descriptionContentLabel.topAnchor.constraint(equalTo: descriptionTitleLable.bottomAnchor, constant: 4),
            descriptionContentLabel.leadingAnchor.constraint(equalTo: descriptionTitleLable.leadingAnchor),
            descriptionContentLabel.trailingAnchor.constraint(equalTo: descriptionTitleLable.trailingAnchor)
        ])
    }
    
    /// Sets up the layout and constraints for the price section
    /// - Parameter price: The price of the item
    private func priceSetup(price: String) {
        addSubview(totalPriceLabel)
        addSubview(priceView)
        
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            totalPriceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            priceView.topAnchor.constraint(equalTo: totalPriceLabel.bottomAnchor, constant: 7),
            priceView.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 25),
            priceView.widthAnchor.constraint(equalToConstant: CGFloat(25 + 10 + (18 * price.count))) // vBucks icon + price widths
        ])
    }
}
