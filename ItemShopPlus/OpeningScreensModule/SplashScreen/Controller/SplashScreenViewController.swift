//
//  SplashScreenViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    // MARK: - Properties
    
    // The splash screen view displayed during app launch
    private let splashView = SplashScreenView()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backSplash
        view.addSubview(splashView)
        
        setConstraints()
        transferToPage()
    }
    
    // MARK: - Helper Methods
    
    // Determines which page to transfer to and performs the transition
    private func transferToPage() {
        // Check if the onboarding page has passed
        let transferMain = UserDefaults.standard.bool(forKey: Texts.OnboardingScreen.userDefaultsKey)
        
        // Choose the appropriate view controller based on onboarding status
        let vc = transferMain ? UINavigationController(rootViewController: MainPageViewController()) : OnboardingViewController()
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        // Perform the transition after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.view.window?.rootViewController = vc
            }, completion: nil)
        }
    }
    

    // Sets up the constraints for the splash view
    private func setConstraints() {
        NSLayoutConstraint.activate([
            splashView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            splashView.heightAnchor.constraint(equalTo: splashView.widthAnchor, multiplier: 1.42)
        ])
        splashView.translatesAutoresizingMaskIntoConstraints = false
    }

}
