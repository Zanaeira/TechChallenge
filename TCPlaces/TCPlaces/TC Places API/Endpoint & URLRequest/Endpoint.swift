//
//  Endpoint.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
}
