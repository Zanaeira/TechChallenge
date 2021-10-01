//
//  Place.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import Foundation

public struct Place: Equatable {
    
    public let id: UUID
    public let place: String
    public let population: Int
    public let currency: String
    public let date: String
    
    public init(id: UUID, place: String, population: Int, currency: String, date: String) {
        self.id = id
        self.place = place
        self.population = population
        self.currency = currency
        self.date = date
    }
    
}
