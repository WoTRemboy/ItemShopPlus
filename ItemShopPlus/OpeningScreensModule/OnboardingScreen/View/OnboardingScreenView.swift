//
//  OnboardingScreenView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 9/23/24.
//

import UIKit
import SwiftUI

class OnboardingViewController: UIViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleTransferToMain), name: .transferToMainPage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @objc private func handleTransferToMain() {
        transferToMain()
    }
    
    private func transferToMain() {
        let vc = MainPageViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen

        UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.window?.rootViewController = navVC
        }, completion: nil)
    }
    
    private func setupUI() {
        // Create an instance of the SwiftUI View
        let onboardingView = OnboardingScreenSwiftUIView()
            .environmentObject(OnboardingViewModel()) // Pass the ViewModel
        
        // Embed it using UIHostingController
        let hostingController = UIHostingController(rootView: onboardingView)
        
        // Add as a child view controller
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        // Set constraints to make the SwiftUI view take up the full screen
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        hostingController.didMove(toParent: self)
    }
}
