//
//  ShopTimerInfoView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

class ShopTimerInfoView: UIView {
    
    // MARK: - UI Elements and Views
    
    private let timerView = TimerRemainingView()
    private let swipeMeaningView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.whatMeans, content: Texts.ShopTimer.swipeInfo, image: .ShopMain.pagesInfo)
    private let countMeaningView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.whatMeans, content: Texts.ShopTimer.countInfo, image: .ShopMain.grantedInfo)
    private let aboutRotationView = CollectionParametersRowView(frame: .null, title: Texts.ShopTimer.aboutRotation, content: Texts.ShopTimer.rotationInfo)
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ShopMain.infoFish
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
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
    
    public func setInfoLabelText(text: String) {
        timerView.updateTimer(content: text)
    }
    
    // MARK: - UI Setup

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
            infoImageView.topAnchor.constraint(equalTo: topAnchor),
            infoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoImageView.heightAnchor.constraint(equalTo: infoImageView.widthAnchor, multiplier: 1080 / 1920),
            
            stackView.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            swipeMeaningView.heightAnchor.constraint(equalToConstant: 70),
            countMeaningView.heightAnchor.constraint(equalToConstant: 70),
            aboutRotationView.heightAnchor.constraint(equalToConstant: 70),
            
            timerView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            timerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
