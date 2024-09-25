//
//  SplashScreenViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    private let splashView = SplashScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backSplash
        view.addSubview(splashView)
        
        setConstraints()
        transferToPage()
    }
    
    private func transferToPage() {
        let transferMain = UserDefaults.standard.bool(forKey: Texts.OnboardingScreen.userDefaultsKey)
        
        let vc = transferMain ? UINavigationController(rootViewController: MainPageViewController()) : OnboardingViewController()
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.view.window?.rootViewController = vc
            }, completion: nil)
        }
    }
    

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
