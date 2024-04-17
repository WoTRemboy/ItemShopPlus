//
//  NicknamePopupViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 13.04.2024.
//

import UIKit

final class NicknamePopupViewController: UIViewController {
    
    private let nicknameView = NicknamePopupView()
    private var nicknameViewCenterYConstraint: NSLayoutConstraint?
    
    public var completionHandler: ((String, String?) -> Void)?
    private var currentNickname = String()
    private var platform: String? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.appearance().isExclusiveTouch = false
        
        nicknameViewSetup()
        setupUI()
        registerKeyboardNotifications()
    }
    
    @objc private func saveNickname() {
        if let retrievedString = UserDefaults.standard.string(forKey: Texts.StatsPage.nicknameKey) {
            currentNickname = retrievedString
        }
        if let text = nicknameView.textField.text, !text.isEmpty {
            completionHandler?(text, platform)
            hide()
        } else {
            SimpleViewsSetup.alertControllerSetup(title: Texts.NicknamePopup.empty, message: Texts.NicknamePopup.emptyMessage, parent: self)
        }
        
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.alpha = 0
            self.nicknameView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: true)
            self.removeFromParent()
        }
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        switch selectedSegment {
        case 0:
            platform = "xbl"
        case 1:
            platform = nil
        case 2:
            platform = "psn"
        default:
            platform = nil
        }
    }
    
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
    
    @objc private func keyboardWillHide(notification: Notification) {
        self.nicknameViewCenterYConstraint?.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    internal func appear(sender: UIViewController, firstAppear: Bool) {
        sender.present(self, animated: firstAppear) {
            self.show()
        }
    }
    
    private func show() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.view.alpha = 1
            self.nicknameView.alpha = 1
        }
    }
    
    private func nicknameViewSetup() {
        view.alpha = 0
        nicknameView.alpha = 0
        view.backgroundColor = .black.withAlphaComponent(0.6)
        nicknameView.layer.cornerRadius = 20
        
        nicknameView.saveButton.addTarget(self, action: #selector(saveNickname), for: .touchUpInside)
        nicknameView.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
