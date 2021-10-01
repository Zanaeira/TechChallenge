//
//  SceneDelegate.swift
//  TCPlacesApp
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import UIKit
import TCPlacesiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        coordinator = MainCoordinator(navigationController: navigationController)
        
        coordinator?.start()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
