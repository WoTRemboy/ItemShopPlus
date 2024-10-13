//
//  NicknamePopupViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 13.04.2024.
//

import UIKit

/// A view controller that manages a popup for entering the player's nickname and selecting a platform
final class NicknamePopupViewController: UIViewController {
    
    // MARK: - Properties
    
    /// A completion handler that passes the entered nickname and selected platform when the nickname is saved
    public var completionHandler: ((String, String?) -> Void)?
    /// The current nickname of the player
    private var currentNickname = String()
    /// The selected platform (e.g., Xbox, PlayStation, Epic)
    private var platform: String? = nil
    
    // MARK: - UI Elements
    
    /// The main view that contains the nickname input and platform selection UI
    private let nicknameView = NicknamePopupView()
    /// The constraint to manage the vertical position of the view, used to adjust for the keyboard
    private var nicknameViewCenterYConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        // Sets the modal presentation style
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.appearance().isExclusiveTouch = false
        
        nicknameViewSetup()
        setupUI()
        registerKeyboardNotifications()
    }
    
    // MARK: - Actions
    
    /// Saves the entered nickname and selected platform. If no nickname is entered, shows an alert
    @objc private func saveNickname() {
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.StatsPage.nicknameKey) {
            currentNickname = retrievedString
        }
        if let text = nicknameView.textField.text, !text.isEmpty {
            completionHandler?(text, platform)
            hide()
        } else {
            // Show an alert if the text field is empty
            SimpleViewsSetup.alertControllerSetup(title: Texts.NicknamePopup.empty, message: Texts.NicknamePopup.emptyMessage, parent: self)
        }
        
    }
    
    /// Hides the popup by animating it out of view
    @objc private func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.alpha = 0
            self.nicknameView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: true)
            self.removeFromParent()
        }
    }
    
    /// Handles the selection of a platform from the segmented control
    /// - Parameter sender: Triggered segment control
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        switch selectedSegment {
        case 0:
            platform = "xbl" // Xbox Live platform code
        case 1:
            platform = nil // Epic Games (no specific platform)
        case 2:
            platform = "psn" // PlayStation Network platform code
        default:
            platform = nil
        }
    }
    
    // MARK: - Keyboard Handling
    
    /// Adjusts the view when the keyboard is about to be shown by moving the nickname view up
    @objc private func keyboardWillShow(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.nicknameViewCenterYConstraint?.constant = -100
                UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    /// Resets the view's position when the keyboard is hidden
    @objc private func keyboardWillHide(notification: Notification) {
        self.nicknameViewCenterYConstraint?.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    /// Registers for keyboard notifications to handle keyboard appearance and disappearance
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Popup Display Methods
    
    /// Presents the nickname popup on the given view controller
    /// - Parameters:
    ///   - sender: The view controller that presents the popup
    ///   - firstAppear: A flag indicating whether this is the first appearance of the popup
    internal func appear(sender: UIViewController, firstAppear: Bool) {
        sender.present(self, animated: firstAppear) {
            self.show()
        }
    }
    
    /// Animates the nickname view into visibility
    private func show() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.view.alpha = 1
            self.nicknameView.alpha = 1
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the nickname view, including its buttons and initial properties
    private func nicknameViewSetup() {
        view.alpha = 0
        nicknameView.alpha = 0
        view.backgroundColor = .black.withAlphaComponent(0.6)
        nicknameView.layer.cornerRadius = 20
        
        // Set up save and cancel buttons
        nicknameView.saveButton.addTarget(self, action: #selector(saveNickname), for: .touchUpInside)
        nicknameView.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    /// Sets up the overall UI by adding the nickname view to the main view and setting constraints
    private func setupUI() {
        view.addSubview(nicknameView)
        nicknameView.translatesAutoresizingMaskIntoConstraints = false
        nicknameViewCenterYConstraint = nicknameView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        guard let nicknameViewCenterYConstraint else { return }
        
        NSLayoutConstraint.activate([
            nicknameView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameViewCenterYConstraint,
            nicknameView.widthAnchor.constraint(equalToConstant: 300),
            nicknameView.heightAnchor.constraint(equalToConstant: 185)
        ])
    }
    
    // MARK: - Deinitialization
    
    deinit {
        // Removes keyboard notification observers
        NotificationCenter.default.removeObserver(self)
    }
    
}
