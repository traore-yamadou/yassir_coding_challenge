//
//  MoviesViewModel.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import Foundation
import CoreData

final class MoviesListViewModel {

    var nextPage = 1

    private let loader: MovieLoader
    private let storage: MovieStorage

    init(loader: MovieLoader, storage: MovieStorage) {
        self.loader = loader
        self.storage = storage
    }

    func shouldLoadMoreMovies(lastMovieIndexPath: IndexPath) -> Bool {
        return lastMovieIndexPath.row == numberOfRowsIn(section: 0) - 1
    }

    // MARK: - Storage
    var fetchedResultsController: NSFetchedResultsController<MovieManagedObject>? {
        return (storage as? CoreDataPostStorage)?.fetchedResultsController
    }

    func findMovie(at indexPath: IndexPath) -> Movie {
        return storage.findMovie(at: indexPath)
    }

    func numberOfRowsIn(section: Int) -> Int {
        return storage.numberOfRowsIn(section: section)
    }
    
    // MARK: - Service
    func loadMovies(completion: @escaping((MovieLoaderError?) -> ())) {
        loader.load(page: nextPage) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.nextPage += 1
                self?.storage.save(movies: movies, completion: {})
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func getThumbnailUrl(of movie: Movie) -> URL? {
        return loader.getThumbnailUrl(of: movie)
    }
}
