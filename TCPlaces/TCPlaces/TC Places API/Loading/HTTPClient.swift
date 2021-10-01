//
//  HTTPClient.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import Foundation

public protocol HTTPClient {
    typealias Completion = (Result<(Data, HTTPURLResponse), Error>) -> Void
    
    func perform(_ request: URLRequest, completion: @escaping Completion)
}
