//
//  RemotePlaceLoader.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 11/09/2021.
//

import Foundation

public final class RemotePlaceLoader: PlaceLoader {
    
    public typealias Result = PlaceLoader.Result
    
    private let urlRequest: URLRequest
    private let client: HTTPClient
    
    public init(urlRequest: URLRequest, client: HTTPClient) {
        self.urlRequest = urlRequest
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.perform(urlRequest) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                completion(RemotePlaceLoader.map(data, from: response))
            case .failure:
                completion(.failure(NetworkError.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let places = try PlaceMapper.map(data, from: response)
            return .success(mapToModel(places))
        } catch {
            return .failure(error)
        }
    }
    
    private static func mapToModel(_ remotePlaces: [RemotePlace]) -> [Place] {
        return remotePlaces.map { $0.modelPlace }
    }
    
}
