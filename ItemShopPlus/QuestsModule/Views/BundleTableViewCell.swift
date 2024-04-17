//
//  TableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 10.12.2023.
//

import UIKit

final class BundleTableViewCell: UITableViewCell, UITableViewDelegate {
    static let identifier = Texts.BundleQuestsCell.identifier
    private var imageLoadTask: URLSessionDataTask?
    
    private let bundleImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Placeholder.noImage
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let bundleBackgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = .Quests.bundleBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let bundleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .title()
        label.text = Texts.BundleQuestsCell.bundleName
        label.textColor = .labelPrimary
        label.numberOfLines = 2
        return label
    }()
    
    private let bundleTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .subhead()
        label.text = Texts.BundleQuestsCell.bundleDate
        label.textColor = .labelTertiary
        label.numberOfLines = 1
        return label
    }()
    
    public func configurate(with name: String, _ image: String, _ date: Date?) {
        bundleNameLabel.text = name
        imageLoadTask = ImageLoader.loadAndShowImage(from: image, to: bundleImageView)
        
        if let end = date {
            let diff = DateFormating.differenceBetweenDates(date1: .now, date2: end)
            bundleTimeLabel.text = diff
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.cancelImageLoad(task: imageLoadTask)
        bundleImageView.image = .Placeholder.noImage
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bundleNameLabel)
        contentView.addSubview(bundleTimeLabel)
        contentView.addSubview(bundleBackgroundImageView)
        contentView.addSubview(bundleImageView)
                        
        bundleNameSetup()
        bundleTimeSetup()
        bundleImageViewSetup()
        bundleBackgroundImageViewSetup()
    }
    
    private func bundleNameSetup() {
        NSLayoutConstraint.activate([
            bundleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            bundleNameLabel.trailingAnchor.constraint(equalTo: bundleImageView.leadingAnchor, constant: -16),
            bundleNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -13)
        ])
        bundleNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bundleTimeSetup() {
        NSLayoutConstraint.activate([
            bundleTimeLabel.leadingAnchor.constraint(equalTo: bundleNameLabel.leadingAnchor),
            bundleTimeLabel.trailingAnchor.constraint(equalTo: bundleNameLabel.trailingAnchor),
            bundleTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 13)
        ])
        bundleTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bundleImageViewSetup() {
        NSLayoutConstraint.activate([
            bundleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bundleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bundleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bundleImageView.widthAnchor.constraint(equalTo: bundleImageView.heightAnchor)
        ])
        bundleImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bundleBackgroundImageViewSetup() {
        NSLayoutConstraint.activate([
            bundleBackgroundImageView.trailingAnchor.constraint(equalTo: bundleImageView.trailingAnchor),
            bundleBackgroundImageView.topAnchor.constraint(equalTo: bundleImageView.topAnchor),
            bundleBackgroundImageView.bottomAnchor.constraint(equalTo: bundleImageView.bottomAnchor),
            bundleBackgroundImageView.widthAnchor.constraint(equalTo: bundleImageView.heightAnchor)
        ])
        bundleBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
