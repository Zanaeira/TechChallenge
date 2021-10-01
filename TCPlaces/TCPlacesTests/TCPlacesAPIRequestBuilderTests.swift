//
//  TCPlacesAPIRequestBuilderTests.swift
//  TCPlacesTests
//
//  Created by Suhayl Ahmed on 10/09/2021.
//

import XCTest
import TCPlaces

class TCPlacesAPIRequestBuilderTests: XCTestCase {
    
    func test_getDemographicsURLRequest_URLRequestHTTPMethodIsGET() {
        let sut: URLRequest = TCPlacesAPIURLRequestBuilder.getDemographicsURLRequest()
        
        var expectedUrlRequest = URLRequest(url: URL(string: "https://anyUrl.com")!)
        expectedUrlRequest.httpMethod = "GET"
        
        XCTAssertEqual(sut.httpMethod, expectedUrlRequest.httpMethod)
    }
    
    func test_getDemographicsURLRequest_URLRequestURLIsCorrect() {
        let expectedUrl = URL(string: "https://d521ed20-4eae-4ee4-83fb-48b45afb2173.mock.pstmn.io/v1/demographics")!
        let sut: URLRequest = TCPlacesAPIURLRequestBuilder.getDemographicsURLRequest()
        
        XCTAssertEqual(sut.url, expectedUrl)
    }
    
    func test_createDemographicsURLRequest_URLRequestHTTPMethodIsPOST() {
        let sut: URLRequest = TCPlacesAPIURLRequestBuilder.createDemographicsURLRequest(place: "", population: 0, currency: "", date: Date())
        
        var expectedUrlRequest = URLRequest(url: URL(string: "https://anyUrl.com")!)
        expectedUrlRequest.httpMethod = "POST"
        
        XCTAssertEqual(sut.httpMethod, expectedUrlRequest.httpMethod)
    }
    
    func test_createDemographicsURLRequest_URLRequestBodyHasCorrectPayload() {
        let place = "Bangladesh"
        let population = 166675572
        let currency = "BDT"
        let now = Date()
        let date = DateFormatter.iso8601DateFormatter.string(from: now)
        
        let sut: URLRequest = TCPlacesAPIURLRequestBuilder.createDemographicsURLRequest(place: place, population: population, currency: currency, date: now)
        
        let payload: [String: AnyHashable] = [
            "place": place,
            "population": population,
            "currency": currency,
            "date": date
        ]
        
        let expected = try? JSONSerialization.jsonObject(with: sut.httpBody!, options: .allowFragments)
        
        XCTAssertEqual(expected as! [String : AnyHashable], payload)
    }
    
}
