//
//  PlacesCollectionViewController.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import UIKit
import TCPlaces

final class PlacesCollectionViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let collectionView: UICollectionView
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, PlaceViewModel> = createDataSource(for: collectionView)
    
    var coordinator: MainCoordinator?
    var onRefresh: (() -> Void)?
    
    init() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: PlacesCollectionViewController.createLayout())
        
        super.init(nibName: nil, bundle: nil)
        
        collectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
        configureHierarchy()
        configurePullToRefresh()
    }
    
    func updatePlaces(_ places: [Place]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PlaceViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(map(places), toSection: .main)
        
        dataSource.apply(snapshot)
    }
    
    private func map(_ places: [Place]) -> [PlaceViewModel] {
        places.map { PlaceViewModel(placeName: $0.place, population: $0.population, currency: $0.currency, dateString: $0.date) }
    }
    
    @objc private func refresh() {
        onRefresh?()
        collectionView.refreshControl?.endRefreshing()
    }
    
}

// MARK: - CollectionView helpers
private extension PlacesCollectionViewController {
    
    private static func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.backgroundColor = .tertiarySystemGroupedBackground
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func createDataSource(for collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, PlaceViewModel> {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PlaceViewModel> { (cell, indexPath, item) in
            cell.configure(with: item)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, PlaceViewModel>(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    private func configureHierarchy() {
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    private func configurePullToRefresh() {
        let refreshControl = UIRefreshControl()
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
    }
    
}

// MARK: - CollectionViewDelegate
extension PlacesCollectionViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placeViewModel = dataSource.snapshot().itemIdentifiers[indexPath.row]
        coordinator?.didSelectPlace(placeViewModel)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

private enum Section {
    case main
}

private extension UICollectionViewListCell {
    
    func configure(with viewModel: PlaceViewModel) {
        var content = defaultContentConfiguration()
        
        content.text = viewModel.placeName
        content.textProperties.font = .preferredFont(forTextStyle: .title1)
        content.textProperties.alignment = .center
        content.secondaryText = "Population: \(viewModel.population)\nCurrency: \(viewModel.currency)\nDate: \(viewModel.formattedDate)"
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .body)
        content.prefersSideBySideTextAndSecondaryText = false
        
        contentConfiguration = content
    }
    
}
