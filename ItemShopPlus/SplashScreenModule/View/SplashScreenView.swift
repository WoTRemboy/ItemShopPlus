//
//  SplashScreenView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

final class SplashScreenView: UIView {

    let splashImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.SplashScreen.splashScreen
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(splashImageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.topAnchor.constraint(equalTo: topAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            splashImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            splashImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            splashImageView.heightAnchor.constraint(equalTo: splashImageView.widthAnchor, multiplier: 1.42)
        ])
    }

}
