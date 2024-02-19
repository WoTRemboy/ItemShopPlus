//
//  NoInternetView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.01.2024.
//

import UIKit

class NoInternetView: UIView {

    private let noInternetLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.noConnection.noInternet
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let retryLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.noConnection.retry
        label.textColor = .labelPrimary
        label.font = .segmentTitle()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let reloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reload", for: .normal)
        button.backgroundColor = .IconColors.backgroundPages
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .title()
        button.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpOutside)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        return button
    }()
    
    @objc private func buttonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func buttonTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.reloadButton.transform = CGAffineTransform.identity
        }
    }
    
    public func configurate() {
        setupUI()
    }
    
    private func setupUI() {
        addSubview(noInternetLabel)
        addSubview(retryLabel)
        addSubview(reloadButton)
        
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        retryLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noInternetLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            noInternetLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            noInternetLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.bounds.height / 20),
            
            retryLabel.topAnchor.constraint(equalTo: noInternetLabel.bottomAnchor, constant: 2),
            retryLabel.leadingAnchor.constraint(equalTo: noInternetLabel.leadingAnchor),
            retryLabel.trailingAnchor.constraint(equalTo: noInternetLabel.trailingAnchor),
            
            reloadButton.topAnchor.constraint(equalTo: retryLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 20),
            reloadButton.centerXAnchor.constraint(equalTo: noInternetLabel.centerXAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            reloadButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 20),
        ])
    }

}
