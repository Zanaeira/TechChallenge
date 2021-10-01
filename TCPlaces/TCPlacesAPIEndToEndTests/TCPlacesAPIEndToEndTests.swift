//
//  TCPlacesAPIEndToEndTests.swift
//  TCPlacesAPIEndToEndTests
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import XCTest
import TCPlaces

class TCPlacesAPIEndToEndTests: XCTestCase {

    func test_endToEndTCPlacesGETdemographics_matchesFixedTestData() {
        let urlRequest = TCPlacesAPIURLRequestBuilder.getDemographicsURLRequest()
        let client = URLSessionHTTPClient()
        let loader = RemotePlaceLoader(urlRequest: urlRequest, client: client)
        
        let exp = expectation(description: "Wait for load to complete.")
        
        var receivedResult: RemotePlaceLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(places):
            XCTAssertEqual(places.count, 2, "Expected 2 items from test server")
        case let .failure(error):
            XCTFail("Expected successful feed result, but got \(error) instead")
        default:
            XCTFail("Expected successful feed result, but got no result instead")
        }
    }
    
    func test_endToEndAirslipPlacesPOSTcreateDemographics_matchesFixedTestData() {
        let urlRequest = TCPlacesAPIURLRequestBuilder.createDemographicsURLRequest(place: "Bangladesh", population: 166675572, currency: "BDT", date: Date())
        let client = URLSessionHTTPClient()
        let uploader = RemotePlaceUploader(urlRequest: urlRequest, client: client)
        
        let exp = expectation(description: "Wait for upload to complete.")
        
        var receivedResult: RemotePlaceUploader.Result?
        uploader.upload { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
        
        switch receivedResult {
        case let .success(id):
            XCTAssertEqual(id.uuidString.uppercased(), "e37607de-282c-4802-b755-8135f6998c96".uppercased(), "Expected test server to return id of: e37607de-282c-4802-b755-8135f6998c96, got \(id.uuidString) instead")
        case let .failure(error):
            XCTFail("Expected successful feed result, but got \(error) instead")
        default:
            XCTFail("Expected successful feed result, but got no result instead")
        }
    }
    
}
