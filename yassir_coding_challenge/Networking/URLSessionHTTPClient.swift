//
//  URLSessionHTTPClient.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(from url: URL, completion: @escaping (Result<(HTTPURLResponse, Data), Error>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((response, data)))
            }
        }.resume()

    }
}
