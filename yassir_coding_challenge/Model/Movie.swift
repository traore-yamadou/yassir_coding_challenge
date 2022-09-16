//
//  Movie.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

struct MovieResponse: Decodable {
    var movies: [Movie]

    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable, Equatable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String 
    let posterPath: String

    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
