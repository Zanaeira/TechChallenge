//
//  RemotePlace.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import Foundation

struct RemotePlace: Decodable {
    private let id: UUID
    private let place: String
    private let population: Int
    private let currency: String
    private let date: String
    
    var modelPlace: Place {
        return Place(id: id, place: place, population: population, currency: currency, date: date)
    }
}
