//
//  SpinnerViewController.swift
//  TCPlacesiOS
//
//  Created by Suhayl Ahmed on 13/09/2021.
//

import UIKit

final class SpinnerViewController: UIViewController {
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerInSuperview()
    }
    
}
