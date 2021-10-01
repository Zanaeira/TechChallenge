//
//  RemotePlaceUploader.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import Foundation

public final class RemotePlaceUploader: PlaceUploader {
    
    public typealias Result = PlaceUploader.Result
    
    private let urlRequest: URLRequest
    private let client: HTTPClient
    
    public init(urlRequest: URLRequest, client: HTTPClient) {
        self.urlRequest = urlRequest
        self.client = client
    }
    
    public func upload(completion: @escaping (Result) -> Void) {
        client.perform(urlRequest) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemotePlaceUploader.map(data, from: response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
    
    private static let CREATED_201: Int = 201
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            guard let createdPlace = try? JSONDecoder().decode(CreatedPlace.self, from: data),
                  response.statusCode == RemotePlaceUploader.CREATED_201 else {
                throw NetworkError.invalidData
            }
            
            return .success(createdPlace.id)
        } catch {
            return .failure(error)
        }
    }
    
}

private struct CreatedPlace: Decodable {
    let id: UUID
}
