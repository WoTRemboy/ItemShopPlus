//
//  MapPickerViewController.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 23.02.2024.
//

import UIKit

/// A view controller that presents a picker allowing users to select a map version from the available map archive
final class MapPickerViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The currently selected map in the picker
    private var currentMap: Map
    /// List of all available maps
    private let maps: [Map]
    
    /// Completion handler to pass the selected map back to the presenting view controller
    public var completionHandler: ((Map) -> Void)?
    
    /// The picker used for selecting a map
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .BackColors.backElevated
        return picker
    }()
    
    // MARK: - Initialization
    
    /// Initializes the view controller with a list of maps and the currently selected map
    /// - Parameters:
    ///   - maps: Array of available maps
    ///   - currentMap: The map that is currently selected
    init(maps: [Map], currentMap: Map) {
        self.maps = maps
        self.currentMap = currentMap
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BackColors.backElevated
        
        navigationBarSetup()
        pickerViewSetup()
    }
    
    // MARK: - Actions
    
    /// Dismisses the view controller without making any changes
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    /// Confirms the selected map and passes it back using the completion handler
    @objc private func doneButtonPressed() {
        completionHandler?(currentMap)
        dismiss(animated: true)
    }
    
    /// Creates a title for each map in the format "v{version} – {release date}"
    /// - Parameters:
    ///   - version: The version of the map
    ///   - date: The release date of the map
    /// - Returns: A formatted string containing the map version and release date
    private func createTitle(version: String, date: Date) -> String {
        let stringDate = DateFormating.dateFormatterDefault(date: date)
        return "v\(version) – \(stringDate)"
    }
    
    // MARK: - UI Setups
    
    /// Configures the navigation bar with cancel and done buttons
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
    
    /// Configures the UIPickerView, sets its delegate and data source, and adds it to the view hierarchy
    private func pickerViewSetup() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Select the currently active map in the picker
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

// MARK: - UIPickerViewDelegate and UIPickerViewDataSource

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
