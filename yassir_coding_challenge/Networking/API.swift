//
//  API.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

/// The API protocol allows us to separate the task of constructing a URL,
/// its parameters, and HTTP method from the act of executing the URL request
/// and parsing the response.
protocol API {

    /// .http  or .https
    var scheme: HTTPScheme { get }

    // Example: "public-api.theMoviedb.com"
    var baseURL: String { get }

    // "/3/discover/movie"
    var path: String { get }

    // [URLQueryItem(name: "page", value: "1")]
    var parameters: [URLQueryItem] { get }

    // "GET"
    var method: HTTPMethod { get }
}
