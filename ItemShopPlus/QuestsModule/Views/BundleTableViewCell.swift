//
//  TableViewCell.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 10.12.2023.
//

import UIKit

class BundleTableViewCell: UITableViewCell, UITableViewDelegate {
    static let identifier = "BundleCell"
    
    let bundleImageView: UIImageView = {
        let view = UIImageView()
        view.image = .imagePlaceholder
        view.backgroundColor = .bundleImageBackground
        view.layer.cornerRadius = 10
        return view
    }()
    
    let bundleName: UILabel = {
        let text = UILabel()
        text.font = .title()
        text.text = "Bundle name..."
        text.textColor = .labelPrimary
        text.numberOfLines = 2
        return text
    }()
    
    let bundleTime: UILabel = {
        let text = UILabel()
        text.font = .subhead()
        text.text = "Until the end of this season"
        text.textColor = .labelTertiary
        text.numberOfLines = 1
        return text
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackSecondary")
        
        contentView.addSubview(bundleName)
        contentView.addSubview(bundleTime)
        contentView.addSubview(bundleImageView)
                        
        bundleNameSetup()
        bundleTimeSetup()
        bundleImageViewSetup()
    }
    
    func bundleNameSetup() {
        NSLayoutConstraint.activate([
            bundleName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            bundleName.trailingAnchor.constraint(equalTo: bundleImageView.leadingAnchor, constant: -16),
            bundleName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -13)
        ])
        bundleName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bundleTimeSetup() {
        NSLayoutConstraint.activate([
            bundleTime.leadingAnchor.constraint(equalTo: bundleName.leadingAnchor),
            bundleTime.trailingAnchor.constraint(equalTo: bundleName.trailingAnchor),
            bundleTime.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 13)
        ])
        bundleTime.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func bundleImageViewSetup() {
        NSLayoutConstraint.activate([
            bundleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bundleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bundleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bundleImageView.widthAnchor.constraint(equalTo: bundleImageView.heightAnchor)
        ])
        bundleImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
