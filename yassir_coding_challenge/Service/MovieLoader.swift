//
//  MovieLoader.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

enum MovieLoaderError: Swift.Error {
    case connectivity
    case invalidData
    case serverSideError
}

protocol MovieLoader {
    func load(page: Int, completion: @escaping(Result<[Movie], MovieLoaderError>) -> Void)
    func getThumbnailUrl(of movie: Movie) -> URL?
}

class RemoteMovieLoader: MovieLoader {

    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load(page: Int, completion: @escaping (Result<[Movie], MovieLoaderError>) -> Void) {
        guard let url = client.buildURL(endpoint: MovieAPI.getMovies(page: page)).url else {
            fatalError("Failed to build url for endpoint \(MovieAPI.getMovies(page: page))")
        }
        
        client.get(from: url) { result in
            switch result {
            case .success((let response, let data)):
                do {
                    let movies = try MovieMapper.map(data, response)
                    completion(.success(movies))
                } catch let error {
                    completion(.failure(error as? MovieLoaderError ?? MovieLoaderError.invalidData))
                }


            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }

    func getThumbnailUrl(of movie: Movie) -> URL? {
        return client.buildURL(endpoint: MovieAPI.getMovieThumbnail(posterPath: movie.posterPath)).url
    }
}
