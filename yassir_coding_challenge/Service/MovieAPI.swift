//
//  MovieAPI.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

/// The MovieAPI enum allows us to separate the task of constructing a URL,
/// its parameters, and HTTP method from the act of executing the URL request
/// and parsing the response.
enum MovieAPI: API {
    case getMovies(page: Int)
    case getMovieThumbnail(posterPath: String)

    var scheme: HTTPScheme {
        switch self {
        case .getMovies, .getMovieThumbnail:
            return .https
        }
    }

    var baseURL: String {
        switch self {
        case .getMovies:
            return "api.themoviedb.org"
        case .getMovieThumbnail:
            return "image.tmdb.org"
        }
    }

    var path: String {
        switch self {
        case .getMovies:
            return "/3/discover/movie"
        case .getMovieThumbnail(let path):
            return "/t/p/w200/\(path)"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getMovies(let page):
            let params = [
                URLQueryItem(name: "api_key", value: String(apiKey)),
                URLQueryItem(name: "page", value: String(page))
            ]
            return params

        case .getMovieThumbnail:
            return []
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getMovies, .getMovieThumbnail:
            return .get
        }
    }
}
