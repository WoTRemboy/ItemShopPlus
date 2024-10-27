////
////  QuestsDetailsViewController.swift
////  ItemShopPlus
////
////  Created by Roman Tverdokhleb on 16.12.2023.
////
//
//import UIKit
//
//class QuestsDetailsViewController: UIViewController {
//    
//    private let item: Quest
//    private let preview = QuestDetailsView()
//    private var imageLoadTask: URLSessionDataTask?
//    
//    private let cancelButton: UIBarButtonItem = {
//        let button = UIBarButtonItem()
//        button.title = Texts.Navigation.cancel
//        button.action = #selector(cancelButtonTapped)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationBarSetup()
//        view.backgroundColor = .BackColors.backElevated
//        
//        view.addSubview(preview)
//                
//        setConstraints()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        setupContent()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        ImageLoader.cancelImageLoad(task: imageLoadTask)
//    }
//    
//    init(item: Quest) {
//        self.item = item
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func navigationBarSetup() {
//        navigationItem.title = Texts.Pages.details
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: Texts.Navigation.cancel,
//            style: .plain,
//            target: self,
//            action: #selector(cancelButtonTapped)
//        )
//    }
//    
//    @objc func cancelButtonTapped() {
//        dismiss(animated: true)
//    }
//    
//    private func setupContent() {
//        if let image = item.image {
//            imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: preview.rewardImageView)
//        } else {
//            preview.rewardImageView.image = .Quests.experience
//        }
//        
//        if let xpReward = item.xpReward, let itemReward = item.itemReward, xpReward != 0 {
//            preview.rewardLabel.text = Texts.QuestDetails.rewards + "\(itemReward) + \(xpReward)" + Texts.QuestDetails.xp
//        } else if let xpReward = item.xpReward, xpReward != 0 {
//            preview.rewardLabel.text = Texts.QuestDetails.reward + String(xpReward) + Texts.QuestDetails.xp
//        } else if let itemReward = item.itemReward {
//            preview.rewardLabel.text = Texts.QuestDetails.reward + itemReward
//        }  /* Some dirt :( */
//        
//        preview.taskLabel.text = item.name
//        preview.requirementLabel.text = Texts.QuestDetails.requirement + item.progress
//    }
//    
//    private func setConstraints() {
//        NSLayoutConstraint.activate([
//            preview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            preview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            preview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            preview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            preview.rewardImageView.heightAnchor.constraint(lessThanOrEqualToConstant: (100 / 812 * view.frame.height))
//        ])
//        preview.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//}
