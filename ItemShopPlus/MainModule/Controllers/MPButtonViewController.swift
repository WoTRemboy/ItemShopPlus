//
//  MPButtonViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MPButtonViewController: UIViewController {
    
    private let shopButton = MPButtonView(frame: .null, buttonType: .shop)
    private let tournamentButton = MPButtonView(frame: .null, buttonType: .tournaments)
    private let newsButton = MPButtonView(frame: .null, buttonType: .news)
    private let questsButton = MPButtonView(frame: .null, buttonType: .quests)
    private let crewButton = MPButtonView(frame: .null, buttonType: .crew)
    private let mapButton = MPButtonView(frame: .null, buttonType: .map)
    private let vehiclesButton = MPButtonView(frame: .null, buttonType: .vehicles)
    private let augumentsButton = MPButtonView(frame: .null, buttonType: .augments)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(shopButton)
        view.addSubview(tournamentButton)
        view.addSubview(newsButton)
        view.addSubview(questsButton)
        view.addSubview(crewButton)
        view.addSubview(mapButton)
        view.addSubview(vehiclesButton)
        view.addSubview(augumentsButton)
        
        shopButtonSetup()
        tournamentButtonSetup()
        newsButtonSetup()
        questsButtonSetup()
        crewButtonSetup()
        mapButtonSetup()
        vehiclesButtonSetup()
        augumentsButtonSetup()
    }
    
    private func shopButtonSetup() {
        NSLayoutConstraint.activate([
            shopButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (28 / 812 * view.frame.height)),
            shopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shopButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            shopButton.heightAnchor.constraint(equalToConstant: (120 / 812 * view.frame.height))
        ])
    }
    
    private func newsButtonSetup() {
        NSLayoutConstraint.activate([
            newsButton.topAnchor.constraint(equalTo: shopButton.topAnchor),
            newsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            newsButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            newsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func tournamentButtonSetup() {
        NSLayoutConstraint.activate([
            tournamentButton.topAnchor.constraint(equalTo: shopButton.bottomAnchor, constant: 16),
            tournamentButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            tournamentButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            tournamentButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func questsButtonSetup() {
        NSLayoutConstraint.activate([
            questsButton.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: 16),
            questsButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            questsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            questsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func crewButtonSetup() {
        NSLayoutConstraint.activate([
            crewButton.topAnchor.constraint(equalTo: tournamentButton.bottomAnchor, constant: 16),
            crewButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            crewButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            crewButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func mapButtonSetup() {
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: questsButton.bottomAnchor, constant: 16),
            mapButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            mapButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            mapButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func vehiclesButtonSetup() {
        NSLayoutConstraint.activate([
            vehiclesButton.topAnchor.constraint(equalTo: crewButton.bottomAnchor, constant: 16),
            vehiclesButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            vehiclesButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            vehiclesButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func augumentsButtonSetup() {
        NSLayoutConstraint.activate([
            augumentsButton.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 16),
            augumentsButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            augumentsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            augumentsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
}
