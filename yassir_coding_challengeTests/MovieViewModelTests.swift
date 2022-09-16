//
//  MovieViewModelTests.swift
//  yassir_coding_challengeTests
//
//  Created by Yamadou Traore on 16/09/2022.
//

import XCTest
@testable import yassir_coding_challenge

class PostsViewModelTests: XCTestCase {

    func testLoadPostsDeliversErrorOnLoaderError() {
        // Given
        let (sut, _) = makeSUT(loader: MockPostLoaderFailure())

        // When
        sut.loadMovies { error in
            // Then
            XCTAssertNotNil(error)
        }
    }

    func testLoadPostsSavesPostsWhenNoError() {
        // Given
        let (sut, storage) = makeSUT(loader: MockPostLoaderSuccess())

        // When
        sut.loadMovies { _ in }

        // Then
        let postCount = (storage as? MockPostsStorage)?.movies.count
        let movie1 = (storage as? MockPostsStorage)?.movies.first
        let movie2 = (storage as? MockPostsStorage)?.movies.last

        XCTAssertEqual(postCount, 4)
        XCTAssertEqual(movie1?.id, 1234)
        XCTAssertEqual(movie2?.id, 5678)
    }

    func testNumberOfRowsInSectionReturnsCorrectNumber() {
        // Given
        let (sut, _) = makeSUT(loader: MockPostLoaderSuccess())
        sut.loadMovies { _ in }

        // When
        let rowCount = sut.numberOfRowsIn(section: 1)

        // Then
        XCTAssertEqual(rowCount, 4)
    }

    func testFindPostAtIndexPathReturnsCorrectPost() {
        // Given
        let (sut, _) = makeSUT(loader: MockPostLoaderSuccess())
        sut.loadMovies { _ in }

        // When
        let movie = sut.findMovie(at: IndexPath(row: 1, section: 1))

        // Then
        XCTAssertEqual(movie.id, 5678)
        XCTAssertEqual(movie.title, "Spiderman")
    }

    // MARK: - Helpers
    private func makeSUT(loader: MovieLoader, file: StaticString = #file, line: UInt = #line) -> (sut: MoviesListViewModel, storage: MovieStorage) {
        let storage = MockPostsStorage()
        let sut = MoviesListViewModel(loader: loader, storage: storage)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Instance should have been deallocated. Potential Memory Leak.", file: file, line: line)
        }
        return (sut, storage)
    }

    private class MockPostsStorage: MovieStorage {

        var movies: [Movie] = []

        func findMovie(at indexPath: IndexPath) -> Movie {
            return movies[indexPath.row]
        }

        func save(movies: [Movie], completion: @escaping (() -> ())) {
            for movie in movies {
                self.movies.append(movie)
            }
            completion()
        }

        func numberOfRowsIn(section: Int) -> Int {
            return movies.count
        }
    }

    private class MockPostLoaderSuccess: MovieLoader {
        func load(page: Int, completion: @escaping (Result<[Movie], MovieLoaderError>) -> Void) {
            let movie1 = Movie(id: 1234, title: "Batman", releaseDate: "2022-05-01", overview: "", posterPath: "")
            let movie2 = Movie(id: 5678, title: "Spiderman", releaseDate: "2022-05-03", overview: "", posterPath: "")

            completion(.success([movie1, movie2, movie1, movie2]))
        }

        func getThumbnailUrl(of movie: Movie) -> URL? {
            return nil
        }
    }

    private class MockPostLoaderFailure: MovieLoader {
        func load(page: Int, completion: @escaping (Result<[Movie], MovieLoaderError>) -> Void) {
            completion(.failure(.invalidData))
        }

        func getThumbnailUrl(of movie: Movie) -> URL? {
            return nil
        }
    }
}
