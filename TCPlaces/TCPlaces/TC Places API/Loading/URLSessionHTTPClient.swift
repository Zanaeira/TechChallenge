//
//  URLSessionHTTPClient.swift
//  TCPlaces
//
//  Created by Suhayl Ahmed on 12/09/2021.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnknownValues: Error {}
    
    public func perform(_ request: URLRequest, completion: @escaping Completion) {
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnknownValues()))
            }
        }.resume()
    }
    
}
