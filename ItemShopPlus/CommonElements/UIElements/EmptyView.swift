//
//  EmptyView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 29.01.2024.
//

import UIKit

final class EmptyView: UIView {
    
    // MARK: - Properties & Initialization
    
    private let type: EmptyViewType
    
    init(type: EmptyViewType) {
        self.type = type
        super.init(frame: .null)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements and Views

    private let titleLabel: UILabel = {
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
        button.setTitle(Texts.noConnection.retryButton, for: .normal)
        button.backgroundColor = .IconColors.backgroundPages
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .title()
        button.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpOutside)
        button.addTarget(nil, action: #selector(buttonTouchUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
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
    
    // MARK: - Public Configure Method
    
    public func configurate() {
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(retryLabel)
        addSubview(reloadButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        retryLabel.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -UIScreen.main.bounds.height / 20),
            
            retryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            retryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            retryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            reloadButton.topAnchor.constraint(equalTo: retryLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 20),
            reloadButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            reloadButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
            reloadButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 20),
        ])
    }

}


enum EmptyViewType {
    case stats
    case archive
    case internet
}