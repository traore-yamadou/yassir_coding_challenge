//
//  RemoteMovieLoaderTests.swift
//  yassir_coding_challengeTests
//
//  Created by Yamadou Traore on 16/09/2022.
//

import XCTest
import CoreData
@testable import yassir_coding_challenge

class RemoteMovieLoaderTests: XCTestCase {

    func testInitDoesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedUrls.isEmpty)
    }

    func testLoadRequestDataFromUrl() {
        // Given
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&page=1")!
        let (sut, client) = makeSUT(url: url)

        // When
        sut.load(page: 1) { _ in }

        // Then
        XCTAssertEqual(client.requestedUrls, [url])
    }

    func testLoadTwiceRequestDataFromUrlTwice() {
        let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3&page=1")!
        let (sut, client) = makeSUT(url: url)

        sut.load(page: 1) { _ in }
        sut.load(page: 1) { _ in }

        XCTAssertEqual(client.requestedUrls, [url, url])
    }

    func testLoadDeliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        var capturedResults = [Result<[Movie], MovieLoaderError>]()
        sut.load(page: 1) { capturedResults.append($0) }

        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        XCTAssertEqual(capturedResults, [.failure(.connectivity)])
    }

    func testLoadDeliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            var capturedResults = [Result<[Movie], MovieLoaderError>]()
            sut.load(page: 1) { capturedResults.append($0) }
            guard let data = try? JSONSerialization.data(withJSONObject: ["results": []]) else {
                XCTFail("JSON parsing failure")
                return
            }
            client.complete(withStatusCode: code, data: data, at: index)

            XCTAssertEqual(capturedResults, [.failure(.serverSideError)])
        }
    }

    func testLoadDeliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        var capturedResults = [Result<[Movie], MovieLoaderError>]()
        sut.load(page: 1) { capturedResults.append($0) }

        let invalidJSON = Data("invalid json".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertEqual(capturedResults, [.failure(.invalidData)])
    }

    func testLoadDeliversNoItemsOn200HTTPResponseWithEmpttyJSONList() {
        let (sut, client) = makeSUT()

        var capturedResults = [Result<[Movie], MovieLoaderError>]()
        sut.load(page: 1) { capturedResults.append($0) }

        let emptyListJSON = Data("{\"results\": []}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)

        XCTAssertEqual(capturedResults, [.success([])])
    }

    func testLoadDeliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        var capturedResults = [Result<[Movie], MovieLoaderError>]()
        sut.load(page: 1) { capturedResults.append($0) }

        let movie1 = Movie(id: 1234, title: "Batman", releaseDate: "2022-05-01", overview: "", posterPath: "")
        let movie2 = Movie(id: 5678, title: "Spiderman", releaseDate: "2022-05-03", overview: "", posterPath: "")

        let json = ["results": [makeMovieJson(movie1), makeMovieJson(movie2)]]
        guard let data = try? JSONSerialization.data(withJSONObject: json) else {
            XCTFail("JSON parsing failure")
            return
        }

        client.complete(withStatusCode: 200, data: data)

        let capturedItems = try? capturedResults.last?.get()

        XCTAssertEqual(capturedItems?.count, 2)
        XCTAssertEqual(capturedItems?.first?.id, movie1.id)
        XCTAssertEqual(capturedItems?.first?.title, movie1.title)
        XCTAssertEqual(capturedItems?.last?.id, movie2.id)
        XCTAssertEqual(capturedItems?.last?.title, movie2.title)
    }

    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: RemoteMovieLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteMovieLoader(client: client)
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Instance should have been deallocated. Potential Memory Leak.", file: file, line: line)
        }
        return (sut, client)
    }

    private func makeMovieJson(_ movie: Movie) -> [String: Any] {

        let json = ["id": movie.id,
                    "title": movie.title,
                    "release_date": movie.releaseDate,
                    "overview": movie.overview,
                    "poster_path": movie.posterPath] as [String: Any]

        return json
    }

    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Result<(HTTPURLResponse, Data), Error>) -> Void)]()

        var requestedUrls: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping(Result<(HTTPURLResponse, Data), Error>) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedUrls[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success((response, data)))
        }
    }

    private func makePersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "yassir_coding_challenge")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Creating in-memory store failed with error: \(error)")
            }
        }

        return container
    }
}
