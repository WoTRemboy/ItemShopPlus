//
//  ShopTimerInfoViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

class ShopTimerInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var targetTime: Date? = .none
    private var timer: Timer?
    
    private let infoView = ShopTimerInfoView()

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        navigationBarSetup()
        
        view.addSubview(infoView)
        setConstraints()
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func updateTimer() {
        let timeDifference = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: targetTime ?? .now)
        print(timeDifference)
        
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        let seconds = timeDifference.second ?? 0
        let timerString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        infoView.setInfoLabelText(text: timerString)
        
        if seconds < 0 {
            infoView.setInfoLabelText(text: Texts.ShopPage.reloadShop)
            timer?.invalidate()
        }
    }
    
    // MARK: - UI Setup
    
    private func navigationBarSetup() {
        navigationItem.title = Texts.ShopPage.rotaionTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setupTimer() {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "UTC") {
            calendar.timeZone = timeZone
        }
        
        guard let targetDate = calendar.date(byAdding: .day, value: 1, to: .now) else { return }
        
        var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        targetTime = calendar.date(from: components)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func setConstraints() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
