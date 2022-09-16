//
//  HTTPClient.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

protocol HTTPClient {
    func get(from url: URL, completion: @escaping(Result<(HTTPURLResponse, Data), Error>) -> Void)
}

extension HTTPClient {
    /// Builds the relevant URL components from the values specified
    /// in the API.
    func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        return components
    }
}
