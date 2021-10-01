//
//  PlaceMapper.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import Foundation

final class PlaceMapper {
    
    private init() {}
    
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemotePlace] {
        guard let places = try? JSONDecoder().decode([RemotePlace].self, from: data),
              isValid(response) else {
            throw NetworkError.invalidData
        }
        
        return places
    }
    
    private static func isValid(_ response: HTTPURLResponse) -> Bool {
        // There is a problem with the test server for this challenge / scenario.
        // For some reason, the GET endpoint returns valid data but with a 404 HTTPResponse
        // Instead of a 200. The below code is in order to bypass this server error and for
        // the purposes of completing this challenge.
        return response.statusCode == OK_200 || response.statusCode == 404
    }
    
}
