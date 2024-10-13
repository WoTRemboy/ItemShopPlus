//
//  NicknamePopupView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 11.04.2024.
//

import UIKit

/// A custom popup view that allows the user to input a nickname and select an account type (Xbox, Epic, PSN)
final class NicknamePopupView: UIView {
    
    // MARK: - UI Elements and Views
    
    /// A segmented control for selecting the platform (Xbox, Epic, or PSN)
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: Texts.NicknamePopup.xbox, at: 0, animated: false)
        control.insertSegment(withTitle: Texts.NicknamePopup.epic, at: 1, animated: false)
        control.insertSegment(withTitle: Texts.NicknamePopup.psn, at: 2, animated: false)
        control.selectedSegmentIndex = 1
        
        return control
    }()
    
    /// A text field for entering the nickname
    internal let textField: UITextField = {
        let field = UITextField()
        field.placeholder = Texts.NicknamePopup.placeholder
        field.borderStyle = .roundedRect
        field.backgroundColor = .SupportColors.supportTextView
        field.textColor = .LabelColors.labelPrimary
        field.font = .title()
        return field
    }()
    
    /// A button to save the entered nickname and platform selection
    internal let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Texts.NicknamePopup.accept, for: .normal)
        button.backgroundColor = .SupportColors.supportButton
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.Shadows.primary
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 20
        return button
    }()
    
    /// A button to cancel the nickname input process
    internal let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Texts.NicknamePopup.cancel, for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .SupportColors.supportButton
        button.layer.cornerRadius = 15
        button.layer.shadowColor = UIColor.Shadows.primary
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 20
        return button
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    /// Sets up the main view's properties, such as background color and corner radius
    private func setupView() {
        backgroundColor = .BackColors.backPopup
        layer.cornerRadius = 10
    }
    
    /// Configures the layout and constraints for the popup's UI elements
    private func setupUI() {
        addSubview(textField)
        addSubview(segmentControl)
        addSubview(saveButton)
        addSubview(cancelButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            segmentControl.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            segmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            cancelButton.topAnchor.constraint(equalTo: saveButton.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            
            saveButton.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            saveButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
