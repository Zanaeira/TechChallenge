//
//  PlacesViewController.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import UIKit
import TCPlaces

public final class PlacesViewController: UIViewController {
    
    public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let spinnerViewController = SpinnerViewController()
    
    private let placeLoader: PlaceLoader
    private let placesCollectionViewController = PlacesCollectionViewController()
    
    private let errorLabel = UILabel(text: "", font: .preferredFont(forTextStyle: .headline))
    
    var coordinator: MainCoordinator? {
        didSet {
            placesCollectionViewController.coordinator = coordinator
        }
    }
    
    public init(placeLoader: PlaceLoader) {
        self.placeLoader = placeLoader
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        performInitialDataLoad()
    }
    
    private func configureUI() {
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        setupPlacesCollectionView()
        setupErrorLabel()
        setupPullToRefresh()
    }
    
    private func setupPlacesCollectionView() {
        add(placesCollectionViewController)
        
        placesCollectionViewController.view.fillSuperview()
    }
    
    private func setupErrorLabel() {
        errorLabel.numberOfLines = 0
        errorLabel.sizeToFit()
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        view.addSubview(errorLabel)
        
        let safeArea = view.safeAreaLayoutGuide
        errorLabel.anchor(top: nil, leading: safeArea.leadingAnchor, bottom: safeArea.bottomAnchor, trailing: safeArea.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 50, right: 0))
    }
    
    private func setupPullToRefresh() {
        placesCollectionViewController.onRefresh = refresh
    }
    
    private func performInitialDataLoad() {
        add(spinnerViewController)
        placeLoader.load { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.spinnerViewController.removeFromParentViewController()
                self.handleResult(result)
            }
        }
    }
    
    @objc private func refresh() {
        placeLoader.load { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.handleResult(result)
            }
        }
    }
    
    private func handleResult(_ result: RemotePlaceLoader.Result) {
        switch result {
        case .success(let places):
            self.errorLabel.text = ""
            self.placesCollectionViewController.updatePlaces(places)
        case .failure(let error):
            self.showError(error)
        }
    }
    
    private func showError(_ error: Error) {
        errorLabel.text = "Something went wrong.\nPlease try again later."
    }
    
}
