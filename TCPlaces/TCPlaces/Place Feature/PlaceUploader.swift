//
//  PlaceUploader.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import Foundation

public protocol PlaceUploader {
    typealias Result = Swift.Result<UUID, Error>
    
    func upload(completion: @escaping (Result) -> Void)
}
