//
//  MainCoordinator.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import UIKit
import TCPlaces

public final class MainCoordinator: Coordinator {
    
    public let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let request = TCPlacesAPIURLRequestBuilder.getDemographicsURLRequest()
        let client = URLSessionHTTPClient()
        let loader = RemotePlaceLoader(urlRequest: request, client: client)
        
        let placesViewController = PlacesViewController(placeLoader: loader)
        placesViewController.coordinator = self
        placesViewController.title = "Places"
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        navigationController.pushViewController(placesViewController, animated: false)
    }
    
    func didSelectPlace(_ placeViewModel: PlaceViewModel) {
        let placeInformationViewController = PlaceInformationViewController(viewModel: placeViewModel)
        placeInformationViewController.title = placeViewModel.placeName
        
        navigationController.pushViewController(placeInformationViewController, animated: true)
    }
    
}
