//
//  TCPlacesAPIURLRequestBuilder.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import Foundation

public struct TCPlacesAPIURLRequestBuilder {
    
    public static func getDemographicsURLRequest() -> URLRequest {
        let endpoint = TCPlacesAPIEndpoint.getDemographics()
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public static func createDemographicsURLRequest(place: String, population: Int, currency: String, date: Date) -> URLRequest {
        let endpoint = TCPlacesAPIEndpoint.createDemographics()
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = "POST"
        
        let isoDate = DateFormatter.iso8601DateFormatter.string(from: date)
        
        let payload: [String: AnyHashable] = [
            "place": place,
            "population": population,
            "currency": currency,
            "date": isoDate
        ]
        let body = try? JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)
        
        request.httpBody = body
        
        return request
    }
    
}
