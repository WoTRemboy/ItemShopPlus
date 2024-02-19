//
//  SplashScreenViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    private let splashView = SplashScreenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backSplash
        
        view.addSubview(splashView)
        setConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = MainPageViewController()
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen

            UIView.transition(with: self.view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.view.window?.rootViewController = navVC
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
