//
//  TCPlacesAPIEndpointTests.swift
//  TCPlacesTests
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import XCTest
@testable import TCPlaces

class TCPlacesAPIEndpointTests: XCTestCase {
    
    func test_getDemographics_pathIsCorrect() {
        let sut: Endpoint = TCPlacesAPIEndpoint.getDemographics()
        let expectedPath = "/v1/demographics"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_getDemographics_urlIsCorrect() {
        let sut: Endpoint = TCPlacesAPIEndpoint.getDemographics()
        let expectedURL = URL(string: "https://d521ed20-4eae-4ee4-83fb-48b45afb2173.mock.pstmn.io/v1/demographics")!
        
        XCTAssertEqual(sut.url, expectedURL)
    }
    
    func test_createDemographics_pathIsCorrect() {
        let sut: Endpoint = TCPlacesAPIEndpoint.createDemographics()
        let expectedPath = "/v1/demographics"
        
        XCTAssertEqual(sut.path, expectedPath)
    }
    
    func test_createDemographics_urlIsCorrect() {
        let sut: Endpoint = TCPlacesAPIEndpoint.createDemographics()
        let expectedURL = URL(string: "https://d521ed20-4eae-4ee4-83fb-48b45afb2173.mock.pstmn.io/v1/demographics")!
        
        XCTAssertEqual(sut.url, expectedURL)
    }
    
}
