//
//  PlaceLoader.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import Foundation

public protocol PlaceLoader {
    typealias Result = Swift.Result<[Place], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
