//
//  Coordinator.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import UIKit

public protocol Coordinator {
    var navigationController: UINavigationController { get }
    
    func start()
}
