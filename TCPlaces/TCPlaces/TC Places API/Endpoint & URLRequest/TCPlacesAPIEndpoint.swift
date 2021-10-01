//
//  TCPlacesAPIEndpoint.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import Foundation

struct TCPlacesAPIEndpoint: Endpoint {
    
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "d521ed20-4eae-4ee4-83fb-48b45afb2173.mock.pstmn.io"
        components.path = path
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        return components.url!
    }
    
    private init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
    
    static func getDemographics() -> TCPlacesAPIEndpoint {
        return TCPlacesAPIEndpoint(path: "/v1/demographics", queryItems: [])
    }
    
    static func createDemographics() -> TCPlacesAPIEndpoint {
        return TCPlacesAPIEndpoint(path: "/v1/demographics", queryItems: [])
    }
    
}
