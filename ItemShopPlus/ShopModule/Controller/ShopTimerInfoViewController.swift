//
//  ShopTimerInfoViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

/// A view controller that displays information about the timer and item shop rotation
final class ShopTimerInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The target time when the shop rotation will reset. Defaults to `nil`
    private var targetTime: Date? = .none
    /// The timer instance used to update the countdown
    private var timer: Timer?
    
    /// A custom view displaying timer information
    private let infoView = ShopTimerInfoView()

    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        navigationBarSetup()
        
        // Add the custom info view and set up constraints
        view.addSubview(infoView)
        setConstraints()
        // Start the timer for countdown updates
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Invalidate the timer to stop updates
        timer?.invalidate()
    }
    
    // MARK: - Actions
    
    /// Handles the event when the "Cancel" button is tapped
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// Updates the timer label to reflect the remaining time until the next shop rotation
    @objc private func updateTimer() {
        // Calculate the time difference between now and the target time
        let timeDifference = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: targetTime ?? .now)
        print(timeDifference)
        
        // Extract hour, minute, and second components
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        let seconds = timeDifference.second ?? 0
        // Format the time difference as a string
        let timerString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        // Update the timer label in the info view
        infoView.setInfoLabelText(text: timerString)
        
        // If the countdown has completed, update the label to indicate a refresh is needed
        if seconds < 0 {
            infoView.setInfoLabelText(text: Texts.ShopPage.reloadShop)
            timer?.invalidate()
        }
    }
    
    // MARK: - UI Setup
    
    /// Sets up the navigation bar with a title and a cancel button
    private func navigationBarSetup() {
        navigationItem.title = Texts.ShopPage.rotaionTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    /// Sets up a timer to update the view with the remaining time until the next shop rotation
    private func setupTimer() {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "UTC") {
            calendar.timeZone = timeZone
        }
        
        // Determine the target time for the shop reset, which is set to midnight (00:00:00) of the next day in UTC
        guard let targetDate = calendar.date(byAdding: .day, value: 1, to: .now) else { return }
        
        // Create date components for the target time
        var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        targetTime = calendar.date(from: components)
        
        // Set up and start a timer that fires every second to update the view
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    /// Configures constraints for the `infoView` layout
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
