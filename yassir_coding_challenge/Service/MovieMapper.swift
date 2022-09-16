//
//  MovieMapper.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation


/// This class is responsible for mapping movies data received from the remote API
internal final class MovieMapper {

    private static var statusCode200 = 200
    private static var statusCode299 = 299

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Movie] {
        guard (statusCode200...statusCode299).contains(response.statusCode) else {
            print("Server side error: statusCode \(response.statusCode) returned.")
            throw MovieLoaderError.serverSideError
        }

        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(MovieResponse.self, from: data)
            return response.movies
        } catch let error {
            print("Error parsing JSON: \(error.localizedDescription).")
            throw MovieLoaderError.invalidData
        }
    }
}
