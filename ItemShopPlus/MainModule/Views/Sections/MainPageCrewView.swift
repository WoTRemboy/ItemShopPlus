//
//  MainPageCrewView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 04.06.2024.
//

import UIKit
import Kingfisher

class MainPageCrewView: UIView {
    
    private var imageLoadTask: DownloadTask?

    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage.Placeholder.noImage16To9
        imageView.image = image
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        button.addTarget(nil, action: #selector(MainPageViewController.crewTransfer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    
    convenience init() {
        self.init(frame: .null)
        
        setupUI()
    }

    // MARK: - Actions
    
    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    public func updateImage(image: String) {
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: buttonImageView, size: CGSize(width: UIScreen.main.nativeBounds.width - 32, height: (UIScreen.main.nativeBounds.width - 32) * 9/16))
    }
    
    private func setupUI() {
        layer.shadowColor = UIColor.Shadows.primary
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 20
        
        addSubview(selectButton)
        addSubview(buttonImageView)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonImageView.topAnchor.constraint(equalTo: topAnchor),
            buttonImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            selectButton.topAnchor.constraint(equalTo: topAnchor),
            selectButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
