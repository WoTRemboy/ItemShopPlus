//
//  ViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class MainPageViewController: UIViewController {
    
    private let shopButton = MPShopButtonView()
    private let tournamentButton = MPTournamentButtonView()
    private let newsButton = MPNewsButtonView()
    private let challengesButton = MPChallengesButtonView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Texts.MainPage.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .backPrimary
        
        view.addSubview(shopButton)
        view.addSubview(tournamentButton)
        view.addSubview(newsButton)
        view.addSubview(challengesButton)
        
        shopButtonSetup()
        tournamentButtonSetup()
        newsButtonSetup()
        challengesButtonSetup()
    }
    
    @objc func sayHi() {
        print("Hi")
    }
    
    private func shopButtonSetup() {
        NSLayoutConstraint.activate([
            shopButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (28 / 812 * view.frame.height)),
            shopButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shopButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            shopButton.heightAnchor.constraint(equalToConstant: (113 / 812 * view.frame.height))
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
    
    private func challengesButtonSetup() {
        NSLayoutConstraint.activate([
            challengesButton.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: 16),
            challengesButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            challengesButton.widthAnchor.constraint(equalTo: shopButton.widthAnchor),
            challengesButton.heightAnchor.constraint(equalTo: shopButton.heightAnchor)
        ])
    }

}

