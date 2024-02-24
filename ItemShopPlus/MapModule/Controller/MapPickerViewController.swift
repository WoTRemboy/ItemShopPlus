//
//  MapPickerViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.02.2024.
//

import UIKit

class MapPickerViewController: UIViewController {
    
    private var currentMap: Map
    private let maps: [Map]
    
    public var completionHandler: ((Map) -> Void)?
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .BackColors.backElevated
        return picker
    }()
    
    init(maps: [Map], currentMap: Map) {
        self.maps = maps
        self.currentMap = currentMap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .BackColors.backElevated
        
        navigationBarSetup()
        pickerViewSetup()
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonPressed() {
        completionHandler?(currentMap)
        dismiss(animated: true)
    }
    
    private func createTitle(version: String, date: Date) -> String {
        let stringDate = DateFormating.dateFormatterShopGranted.string(from: date)
        return "v\(version) – \(stringDate)"
    }
    
    private func navigationBarSetup() {
        navigationItem.title = Texts.MapPage.archive
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.cancel,
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Texts.Navigation.done,
            style: .done,
            target: self,
            action: #selector(doneButtonPressed)
        )
    }
    
    private func pickerViewSetup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let row = maps.firstIndex(where: { $0.realeseDate == currentMap.realeseDate } ) else { return }
        pickerView.selectRow(row, inComponent: 0, animated: false)
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MapPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let map = maps[row]
        return createTitle(version: map.patchVersion, date: map.realeseDate)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let map = maps[row]
        currentMap = map
    }
}
