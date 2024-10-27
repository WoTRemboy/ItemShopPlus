//
//  ShopTimerInfoView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

/// A view that displays timer information and additional contextual details about the shop items
final class ShopTimerInfoView: UIView {
    
    // MARK: - UI Elements and Views
    
    /// A view displaying the remaining time for the shop items
    private let timerView = TimerRemainingView()
    /// A view displaying information about swipe actions in the shop
    private let swipeMeaningView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.whatMeans, content: Texts.ShopTimer.swipeInfo, image: .ShopMain.pagesInfo)
    /// A view displaying information about the number of items in the shop
    private let countMeaningView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.whatMeans, content: Texts.ShopTimer.countInfo, image: .ShopMain.grantedInfo)
    /// A view displaying information about item rotation in the shop
    private let aboutRotationView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.aboutRotation, content: Texts.ShopTimer.rotationInfo)
    
    /// An image view for displaying info illustration
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ShopMain.infoFish
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    /// A stack view for arranging `CollectionParametersRowView` elements vertically
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        timerView.configurate(title: Texts.ShopPage.remaining, content: Texts.ShopPage.remaining)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Configure Method
    
    /// Updates the timer view's label with the time text
    /// - Parameter text: The new time text to display in the timer view
    public func setInfoLabelText(text: String) {
        timerView.updateTimer(content: text)
    }
    
    // MARK: - UI Setup
    
    /// Sets up the UI layout and constraints for the view
    private func setupUI() {
        addSubview(infoImageView)
        addSubview(stackView)
        addSubview(timerView)
        
        stackView.addArrangedSubview(swipeMeaningView)
        stackView.addArrangedSubview(countMeaningView)
        stackView.addArrangedSubview(aboutRotationView)
        
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        timerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Info image view constraints setup
            infoImageView.topAnchor.constraint(equalTo: topAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoImageView.heightAnchor.constraint(equalTo: infoImageView.widthAnchor, multiplier: 1080 / 1920),
            
            // Stack view constraints setup
            stackView.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Info rows height constraints setup
            swipeMeaningView.heightAnchor.constraint(equalToConstant: 70),
            countMeaningView.heightAnchor.constraint(equalToConstant: 70),
            aboutRotationView.heightAnchor.constraint(equalToConstant: 70),
            
            // Timer view constraints setup
            timerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            timerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
