//
//  MPButtonViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MPButtonViewController: UIViewController {
    
    private let shopButton = MPButtonView(frame: .null, buttonType: .shop)
    private let battlePassButton = MPButtonView(frame: .null, buttonType: .battlePass)
    private let crewButton = MPButtonView(frame: .null, buttonType: .crew)
    private let questsButton = MPButtonView(frame: .null, buttonType: .null)
    private let tournamentButton = MPButtonView(frame: .null, buttonType: .null)
    private let statsButton = MPButtonView(frame: .null, buttonType: .null)
    private let mapButton = MPButtonView(frame: .null, buttonType: .map)
    private let cacheButton = MPButtonView(frame: .null, buttonType: .cache)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(shopButton)
        view.addSubview(battlePassButton)
        view.addSubview(crewButton)
        view.addSubview(questsButton)
        view.addSubview(tournamentButton)
        view.addSubview(statsButton)
        view.addSubview(mapButton)
        view.addSubview(cacheButton)
        
        shopButtonSetup()
        battlePassButtonSetup()
        crewButtonSetup()
        questsButtonSetup()
        tournamentButtonSetup()
        statsButtonSetup()
        mapButtonSetup()
        cacheButtonSetup()
    }
    
    private func shopButtonSetup() {
        NSLayoutConstraint.activate([
            shopButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (28 / 812 * view.frame.height)),
            shopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shopButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            shopButton.heightAnchor.constraint(equalToConstant: (120 / 812 * view.frame.height))
        ])
    }
    
    private func battlePassButtonSetup() {
        NSLayoutConstraint.activate([
            battlePassButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            battlePassButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            battlePassButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            battlePassButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func crewButtonSetup() {
        NSLayoutConstraint.activate([
            crewButton.topAnchor.constraint(equalTo: shopButton.bottomAnchor, constant: 16),
            crewButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            crewButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            crewButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func questsButtonSetup() {
        NSLayoutConstraint.activate([
            questsButton.topAnchor.constraint(equalTo: battlePassButton.bottomAnchor, constant: 16),
            questsButton.trailingAnchor.constraint(equalTo: battlePassButton.trailingAnchor),
            questsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            questsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func tournamentButtonSetup() {
        NSLayoutConstraint.activate([
            tournamentButton.topAnchor.constraint(equalTo: crewButton.bottomAnchor, constant: 16),
            tournamentButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            tournamentButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            tournamentButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func statsButtonSetup() {
        NSLayoutConstraint.activate([
            statsButton.topAnchor.constraint(equalTo: questsButton.bottomAnchor, constant: 16),
            statsButton.trailingAnchor.constraint(equalTo: battlePassButton.trailingAnchor),
            statsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            statsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func mapButtonSetup() {
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: tournamentButton.bottomAnchor, constant: 16),
            mapButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            mapButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            mapButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func cacheButtonSetup() {
        NSLayoutConstraint.activate([
            cacheButton.topAnchor.constraint(equalTo: statsButton.bottomAnchor, constant: 16),
            cacheButton.trailingAnchor.constraint(equalTo: battlePassButton.trailingAnchor),
            cacheButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            cacheButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
}
