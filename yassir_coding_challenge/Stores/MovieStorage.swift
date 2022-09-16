//
//  MovieStorage.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation

protocol MovieStorage {
    func save(movies: [Movie], completion: @escaping (() -> ()))
    func findMovie(at indexPath: IndexPath) -> Movie
    func numberOfRowsIn(section: Int) -> Int
}
