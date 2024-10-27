//
//  SceneDelegate.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    // MARK: - UIScene Lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let viewController = SplashScreenViewController()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        
        // Apply user-selected appearance settings if available
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.AppearanceSettings.key) {
            if let style = AppTheme.themes.first(where: { $0.keyValue == retrievedString })?.style {
                window?.overrideUserInterfaceStyle = style
            }
        }
        
        window?.makeKeyAndVisible()
    }
}

