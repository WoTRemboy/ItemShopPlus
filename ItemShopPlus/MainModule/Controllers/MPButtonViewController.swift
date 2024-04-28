//
//  MPButtonViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

final class MPButtonViewController: UIViewController {
    
    private let shopButton = MPButtonView(frame: .null, buttonType: .shop)
    private let battlePassButton = MPButtonView(frame: .null, buttonType: .battlePass)
    private let crewButton = MPButtonView(frame: .null, buttonType: .crew)
    private let bundlesButton = MPButtonView(frame: .null, buttonType: .bundles)
    private let lootDetailsButton = MPButtonView(frame: .null, buttonType: .lootDetails)
    private let statsButton = MPButtonView(frame: .null, buttonType: .stats)
    private let mapButton = MPButtonView(frame: .null, buttonType: .map)
    private let cacheButton = MPButtonView(frame: .null, buttonType: .settings)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(shopButton)
        view.addSubview(battlePassButton)
        view.addSubview(crewButton)
        view.addSubview(bundlesButton)
        view.addSubview(lootDetailsButton)
        view.addSubview(statsButton)
        view.addSubview(mapButton)
        view.addSubview(cacheButton)
        
        shopButtonSetup()
        battlePassButtonSetup()
        crewButtonSetup()
        bundleButtonSetup()
        lootDetailsButtonSetup()
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
    
    private func bundleButtonSetup() {
        NSLayoutConstraint.activate([
            bundlesButton.topAnchor.constraint(equalTo: battlePassButton.bottomAnchor, constant: 16),
            bundlesButton.trailingAnchor.constraint(equalTo: battlePassButton.trailingAnchor),
            bundlesButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            bundlesButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func lootDetailsButtonSetup() {
        NSLayoutConstraint.activate([
            lootDetailsButton.topAnchor.constraint(equalTo: crewButton.bottomAnchor, constant: 16),
            lootDetailsButton.leadingAnchor.constraint(equalTo: shopButton.leadingAnchor),
            lootDetailsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            lootDetailsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func statsButtonSetup() {
        NSLayoutConstraint.activate([
            statsButton.topAnchor.constraint(equalTo: bundlesButton.bottomAnchor, constant: 16),
            statsButton.trailingAnchor.constraint(equalTo: battlePassButton.trailingAnchor),
            statsButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            statsButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }
    
    private func mapButtonSetup() {
        NSLayoutConstraint.activate([
            mapButton.topAnchor.constraint(equalTo: lootDetailsButton.bottomAnchor, constant: 16),
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
