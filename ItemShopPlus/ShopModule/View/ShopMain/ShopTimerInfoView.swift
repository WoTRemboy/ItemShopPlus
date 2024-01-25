//
//  ShopTimerInfoView.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.01.2024.
//

import UIKit

class ShopTimerInfoView: UIView {
    
    private var targetTime: Date? = .none
    var timer: Timer? = .none
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .ShopMain.infoFish
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .body()
        label.textColor = .LabelColors.labelPrimary
        label.text = Texts.ShopPage.rotationInfo
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .title()
        label.textColor = .LabelColors.labelPrimary
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTimer()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    @objc func updateTimer() {
        let timeDifference = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: targetTime ?? .now)
        print(timeDifference)
        
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        let seconds = timeDifference.second ?? 0
        
        let timerString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        timerLabel.text = timerString
        
        if seconds < 0 {
            timerLabel.text = Texts.ShopPage.reloadShop
            timer?.invalidate()
        }
    }
    
    private func setupUI() {
        addSubview(infoImageView)
        addSubview(infoLabel)
        addSubview(timerLabel)
        
        infoImageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoImageView.topAnchor.constraint(equalTo: topAnchor),
            infoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoImageView.heightAnchor.constraint(equalToConstant: 150 / 812 * UIScreen.main.bounds.height),
            infoImageView.widthAnchor.constraint(equalTo: infoImageView.heightAnchor),
            
            timerLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 16),
            timerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10)
        ])
    }
    
}
