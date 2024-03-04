//
//  BattlePassInfoViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit
import AVKit

class BattlePassInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    private let seasonTitle: String
    private let seasonName: String
    private let video: String
    
    private var videoLoadTask: URLSessionDataTask?
    
    private let beginDate: Date
    private let endDate: Date
    private var timer: Timer?
    
    // MARK: - UI Elements and Views
    
    private var playerViewController = AVPlayerViewController()
    
    private let dateView = BattlePassSeasonParameterRow(
        frame: .null,
        beginTitle: Texts.BattlePassItemsParameters.beginDate,
        beginContent: Texts.BattlePassItemsParameters.beginDateData,
        endTitle: Texts.BattlePassItemsParameters.endDate,
        endContent: Texts.BattlePassItemsParameters.endDateData
    )
    private let seasonInfo = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.currentSeason, content: Texts.BattlePassItemsParameters.currentData, textAlignment: .center)
    
    private let remainingView = TimerRemainingView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(seasonId: Int, seasonName: String, video: String?, beginDate: Date, endDate: Date) {
        self.seasonTitle = "\(Texts.BattlePassInfo.season) \(seasonId)"
        self.seasonName = seasonName
        self.video = video ?? String()
        self.beginDate = beginDate
        self.endDate = endDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        VideoLoader.cancelVideoLoad(task: videoLoadTask)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer?.invalidate()
        setupTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        
        navigationBarSetup()
        playerLayout()
        stackViewSetup()
        remainingSetup()
        setupTimer()
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    private func contentSetup() {
        dateView.configurate(content: DateFormating.dateFormatterDMY.string(from: beginDate), DateFormating.dateFormatterDMY.string(from: endDate))
        seasonInfo.configurate(content: seasonName)
    }
    
    // MARK: - Working with Timer
    
    private func setupTimer() {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "UTC") {
            calendar.timeZone = timeZone
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc private func updateTimer() {
        let timeDifference = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute, .second], from: .now, to: endDate)
        print(timeDifference)
        
        let weeks = timeDifference.weekOfYear ?? 0
        let days = timeDifference.day ?? 0
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        let seconds = timeDifference.second ?? 0
        let timerString = String(format: "%01dW %01dD %02d:%02d:%02d", weeks, days, hours, minutes, seconds)
        remainingView.updateTimer(content: timerString)
        
        if seconds < 0 {
            remainingView.updateTimer(content: Texts.BattlePassInfo.newSeason)
            timer?.invalidate()
        }
    }
    
    
    // MARK: - Networking
    
    private func playerSetup() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.videoLoadTask = VideoLoader.loadAndShowVideo(from: self.video, to: self.playerViewController, activityIndicator: self.activityIndicator)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session:", error)
        }
        
    }
    
    // MARK: - UI Setups
    
    private func navigationBarSetup() {
        navigationItem.title = seasonTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        let activityBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        navigationItem.rightBarButtonItem = activityBarButtonItem
    }
    
    private func playerLayout() {
        playerViewController.view.layer.cornerRadius = 10
        playerViewController.view.layer.masksToBounds = true
        
        addChild(playerViewController)
        
        view.addSubview(playerViewController.view)
        playerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            playerViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            playerViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            playerViewController.view.heightAnchor.constraint(equalTo: playerViewController.view.widthAnchor, multiplier: 1380/2450)
        ])
        
        playerViewController.didMove(toParent: self)
        playerSetup()
    }
    
    private func stackViewSetup() {
        stackView.addArrangedSubview(seasonInfo)
        stackView.addArrangedSubview(dateView)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateView.heightAnchor.constraint(equalToConstant: 70),
            seasonInfo.heightAnchor.constraint(equalToConstant: 70),
            
            stackView.topAnchor.constraint(equalTo: playerViewController.view.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        contentSetup()
    }
    
    private func remainingSetup() {
        remainingView.configurate(title: Texts.BattlePassCell.remaining, content: Texts.BattlePassCell.remaining)
        
        view.addSubview(remainingView)
        remainingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            remainingView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            remainingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            remainingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            remainingView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
