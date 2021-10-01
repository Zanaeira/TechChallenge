//
//  RemotePlaceLoaderTests.swift
//  TCPlacesTests
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import XCTest
import TCPlaces

class RemotePlaceLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestData() {
        let (_, client, _) = makeSUT()
        
        XCTAssertEqual(client.requestedUrlRequests, [])
    }
    
    func test_load_performsDataRequest() {
        let (sut, client, request) = makeSUT()
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedUrlRequests, [request])
    }
    
    func test_loadTwice_performsDataRequestTwice() {
        let (sut, client, request) = makeSUT()
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedUrlRequests, [request, request])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client, _) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(NetworkError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client, _) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, statusCode in
            expect(sut, toCompleteWith: .failure(NetworkError.invalidData)) {
                let json = makePlacesJSON([])
                client.complete(withStatusCode: statusCode, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client, _) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(NetworkError.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoPlacesOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client, _) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makePlacesJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversPlacesOn200HTTPResponseWithJSONItems() {
        let (sut, client, _) = makeSUT()
        
        let now = Date()
        
        let place1 = makePlace(id: UUID(), place: "Bangladesh", population: 166675572, currency: "BDT", date: now)
        let place2 = makePlace(id: UUID(), place: "Japan", population: 126015630, currency: "JPY", date: now)
        
        let places = [place1.model, place2.model]
        
        expect(sut, toCompleteWith: .success(places)) {
            let json = makePlacesJSON([place1.json, place2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = HTTPClientSpy()
        let request = URLRequest(url: URL(string: "https://anyUrl.com")!)
        var sut: RemotePlaceLoader? = RemotePlaceLoader(urlRequest: request, client: client)
        
        var capturedResults = [RemotePlaceLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makePlacesJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemotePlaceLoader, client: HTTPClientSpy, request: URLRequest) {
        let client = HTTPClientSpy()
        let request = URLRequest(url: URL(string: "https://anyUrl.com")!)
        let sut = RemotePlaceLoader(urlRequest: request, client: client)
        
        return (sut, client, request)
    }
    
    private func expect(_ sut: RemotePlaceLoader, toCompleteWith expectedResult: RemotePlaceLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPlaces), .success(expectedPlaces)):
                XCTAssertEqual(receivedPlaces, expectedPlaces, file: file, line: line)
            case let (.failure(receivedError as NetworkError), .failure(expectedError as NetworkError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult), but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makePlace(id: UUID, place: String, population: Int, currency: String, date: Date) -> (model: Place, json: [String: Any]) {
        let dateAsString = DateFormatter.iso8601DateFormatter.string(from: date)
        let place = Place(id: id, place: place, population: population, currency: currency, date: dateAsString)
        let json: [String: Any] = [
            "id": place.id.uuidString,
            "place": place.place,
            "population": place.population,
            "currency": place.currency,
            "date": place.date
        ]
        
        return (place, json)
    }
    
    private func makePlacesJSON(_ places: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: places)
    }
    
    final class HTTPClientSpy: HTTPClient {
        
        var urlRequestCompletions = [(urlRequest: URLRequest, completion: Completion)]()
        
        var requestedUrlRequests: [URLRequest] {
            return urlRequestCompletions.map { $0.urlRequest }
        }
        
        private var requestedUrls: [URL] {
            return requestedUrlRequests.compactMap { $0.url }
        }
        
        func perform(_ request: URLRequest, completion: @escaping HTTPClient.Completion) {
            urlRequestCompletions.append((request, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            urlRequestCompletions[index].completion(.failure(error))
        }
        
        func complete(withStatusCode statusCode: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedUrls[index],
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            urlRequestCompletions[index].completion(.success((data, response)))
        }
        
    }
    
}
