//
//  BattlePassInfoViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 02.03.2024.
//

import UIKit
import AVKit
import OSLog

/// A log object to organize messages
private let logger = Logger(subsystem: "BattlePassModule", category: "TimerController")

/// The view controller displays detailed information about the current Battle Pass season, including its video preview, start and end dates, and the time remaining until the next season
final class BattlePassInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The title of the Battle Pass season
    private let seasonTitle: String
    /// URL of the video associated with the season
    private let video: String
    
    /// The network task responsible for downloading the video
    private var videoLoadTask: URLSessionDataTask?
    
    /// The date when the Battle Pass season begins
    private let beginDate: Date
    /// The date when the Battle Pass season ends
    private let endDate: Date
    /// Timer used to update the remaining time until the end of the season
    private var timer: Timer?
    
    // MARK: - UI Elements and Views
    
    /// The player view controller used to display the video for the current Battle Pass season
    private var playerViewController = AVPlayerViewController()
    
    /// A custom view displaying the beginning and ending dates of the current Battle Pass season
    private let dateView = BattlePassSeasonParameterRow(
        frame: .null,
        beginTitle: Texts.BattlePassItemsParameters.beginDate,
        beginContent: Texts.BattlePassItemsParameters.beginDateData,
        endTitle: Texts.BattlePassItemsParameters.endDate,
        endContent: Texts.BattlePassItemsParameters.endDateData
    )
    
    /// A view displaying the current Battle Pass season information
    private let seasonInfo = CollectionParametersRowView(frame: .null, title: Texts.BattlePassItemsParameters.currentSeason, content: Texts.BattlePassItemsParameters.currentData, textAlignment: .center)
    
    /// A view showing the remaining time until the end of the current Battle Pass season
    private let remainingView = TimerRemainingView()
    
    /// Activity indicator displayed during video loading
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    /// Custom initializer to create the controller with the specific Battle Pass information
    /// - Parameters:
    ///   - seasonName: The name of the Battle Pass season
    ///   - video: Optional URL of the season video
    ///   - beginDate: Start date of the season
    ///   - endDate: End date of the season
    init(seasonName: String, video: String?, beginDate: Date, endDate: Date) {
        self.seasonTitle = seasonName
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
        // Invalidates the timer and cancels video loading if necessary
        timer?.invalidate()
        VideoLoader.cancelVideoLoad(task: videoLoadTask)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Initializes the timer to show the remaining time
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
    
    /// Dismisses the current view controller
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// Sets up content views with the provided data
    private func contentSetup() {
        dateView.configurate(content: DateFormating.dateFormatterDefault(date: beginDate), DateFormating.dateFormatterDefault(date: endDate))
        seasonInfo.configurate(content: seasonTitle)
    }
    
    // MARK: - Working with Timer
    
    /// Sets up and starts a timer to update the remaining time until the end of the season
    private func setupTimer() {
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "UTC") {
            calendar.timeZone = timeZone
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    /// Updates the remaining time label based on the current time and the season end date
    @objc private func updateTimer() {
        let timeDifference = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute, .second], from: .now, to: endDate)
        logger.info("Battle Pass Info page timer - \(timeDifference)")
        
        let weeks = timeDifference.weekOfYear ?? 0
        let days = timeDifference.day ?? 0
        let hours = timeDifference.hour ?? 0
        let minutes = timeDifference.minute ?? 0
        let seconds = timeDifference.second ?? 0
        let timerString = String(format: Texts.BattlePassInfo.dateFormat, weeks, days, hours, minutes, seconds)
        remainingView.updateTimer(content: timerString)
        
        if seconds < 0 {
            remainingView.updateTimer(content: Texts.BattlePassInfo.newSeason)
            timer?.invalidate()
        }
    }
    
    
    // MARK: - Networking
    
    /// Sets up and configures the video player with the provided video URL
    private func playerSetup() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            VideoLoader.loadAndShowVideo(from: self.video, to: self.playerViewController, activityIndicator: self.activityIndicator)
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            logger.info("Audio session set up")
        } catch {
            logger.error("Error setting audio session: \(error)")
        }
        
    }
    
    // MARK: - UI Setups
    
    /// Configures the navigation bar with the title and action buttons
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
    
    /// Configures and lays out the player view for the video
    private func playerLayout() {
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
    
    /// Sets up and configures the stack view containing the date and season information
    private func stackViewSetup() {
        view.addSubview(dateView)
        dateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateView.topAnchor.constraint(equalTo: playerViewController.view.bottomAnchor, constant: 25),
            dateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateView.heightAnchor.constraint(equalToConstant: 70),
        ])
        contentSetup()
    }
    
    /// Sets up and configures the view displaying the remaining time until the end of the season
    private func remainingSetup() {
        remainingView.configurate(title: Texts.BattlePassCell.remaining, content: Texts.BattlePassCell.remaining)
        
        view.addSubview(remainingView)
        remainingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            remainingView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 30),
            remainingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            remainingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            remainingView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
