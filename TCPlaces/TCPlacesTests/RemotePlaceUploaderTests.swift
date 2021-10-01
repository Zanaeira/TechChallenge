//
//  RemotePlaceUploaderTests.swift
//  TCPlacesTests
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import XCTest
import TCPlaces

class RemotePlaceUploaderTests: XCTestCase {
    
    func test_init_doesNotPerformUploadRequest() {
        let (_, client, _) = makeSUT()
        
        XCTAssertEqual(client.requestedUrlRequests, [])
    }
    
    func test_upload_performsUploadRequest() {
        let (sut, client, request) = makeSUT()
        
        sut.upload() { _ in }
        
        XCTAssertEqual(client.requestedUrlRequests, [request])
    }
    
    func test_uploadTwice_performsUploadRequestTwice() {
        let (sut, client, request) = makeSUT()
        
        sut.upload() { _ in }
        sut.upload() { _ in }
        
        XCTAssertEqual(client.requestedUrlRequests, [request, request])
    }
    
    func test_upload_deliversErrorOnClientError() {
        let (sut, client, _) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(NetworkError.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_upload_deliversErrorOnNon201HTTPResponse() {
        let (sut, client, _) = makeSUT()
        
        let json = ["id": "b9b3c98d-f16f-43f7-88ba-7ae6aadf7180"]
        
        let samples = [200, 202, 300, 400, 500]
        samples.enumerated().forEach { index, statusCode in
            expect(sut, toCompleteWith: .failure(NetworkError.invalidData)) {
                let json = makePlaceCreatedJSON(json)
                client.complete(withStatusCode: statusCode, data: json, at: index)
            }
        }
    }
    
    func test_upload_deliversErrorOn201HTTPResponseWithInvalidJSON() {
        let (sut, client, _) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(NetworkError.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 201, data: invalidJSON)
        }
    }
    
    func test_upload_deliversNoCreatedPlaceIdOn201HTTPResponseWithEmptyJSONList() {
        let (sut, client, _) = makeSUT()
        
        let id = "b9b3c98d-f16f-43f7-88ba-7ae6aadf7180"
        let json = ["id": id]
        
        expect(sut, toCompleteWith: .success(UUID(uuidString: id)!)) {
            let emptyListJSON = makePlaceCreatedJSON(json)
            client.complete(withStatusCode: 201, data: emptyListJSON)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RemotePlaceUploader, client: HTTPClientSpy, request: URLRequest) {
        let client = HTTPClientSpy()
        let request = URLRequest(url: URL(string: "https://anyUrl.com")!)
        let sut = RemotePlaceUploader(urlRequest: request, client: client)
        
        return (sut, client, request)
    }
    
    private func makePlaceCreatedJSON(_ json: [String: String]) -> Data {
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemotePlaceUploader, toCompleteWith expectedResult: RemotePlaceUploader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for upload completion")
        sut.upload { receivedResult in
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
