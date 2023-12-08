//
//  MPGlobalView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MPGlobalView: UIView {
    
    private let shopButton = MPShopButtonView()
    private let tournamentButton = MPTournamentButtonView()
    private let newsButton = MPNewsButtonView()
    private let challengesButton = MPChallengesButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(shopButton)
        addSubview(tournamentButton)
        addSubview(newsButton)
        addSubview(challengesButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            shopButton.topAnchor.constraint(equalTo: topAnchor),
            shopButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shopButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -8),
            shopButton.heightAnchor.constraint(equalToConstant: (113 / 812 * frame.height)),
            
            newsButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            newsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 8),
            newsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            
            tournamentButton.topAnchor.constraint(equalTo: shopButton.bottomAnchor, constant: 16),
            tournamentButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            tournamentButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            tournamentButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor),
            
            challengesButton.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: 16),
            challengesButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            challengesButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            challengesButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
}
