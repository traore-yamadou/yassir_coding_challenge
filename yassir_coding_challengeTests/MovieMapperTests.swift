//
//  MovieMapperTests.swift
//  yassir_coding_challengeTests
//
//  Created by Yamadou Traore on 16/09/2022.
//

import XCTest
@testable import yassir_coding_challenge

class MovieMapperTests: XCTestCase {

    func testMapDeliversErrorOnStatusCodeNotIn200And299() {
        // Given
        let samples = [300, 400, 500]

        guard let url = URL(string: "http://any-url.com") else {
            XCTFail("URL creation error")
            return
        }
        guard let data = "[0]".data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }

        try? samples.enumerated().forEach { index, code in
            guard let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil) else {
                XCTFail("Invalid response")
                return
            }

            // When
            XCTAssertThrowsError(try MovieMapper.map(data, response)) { error in
                // Then
                XCTAssertEqual(error as? MovieLoaderError, MovieLoaderError.serverSideError)
            }

        }
    }

    func testMapDeliversErrorOn200HTTPResponseWithInvalidJSON() throws {
        // Given
        guard let url = URL(string: "http://any-url.com") else {
            XCTFail("URL creation error")
            return
        }
        guard let data = "[0]".data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            XCTFail("Invalid response")
            return
        }

        // When
        do {
            let _ = try MovieMapper.map(data, response)
        } catch {
            // Then
            XCTAssertEqual(error as! MovieLoaderError, MovieLoaderError.invalidData)
        }
    }

    func testMapDeliversPostsOn200HTTPResponseWithJSONItems() throws {
        // Given
        guard let url = URL(string: "http://any-url.com") else {
            XCTFail("URL creation error")
            return
        }

        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            XCTFail("Invalid response")
            return
        }

        guard let path = Bundle.main.path(forResource: "fakeJSON", ofType: "json") else {
            XCTFail("Invalid path")
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
            XCTFail("Invalid data")
            return
        }

        // When
        let movies = try? MovieMapper.map(data, response)

        // Then
        XCTAssertEqual(movies?.count, 2)
        XCTAssertEqual(movies?.first?.id, 1234)
        XCTAssertEqual(movies?.last?.id, 5678)
        XCTAssertEqual(movies?.first?.title, "Batman")
        XCTAssertEqual(movies?.last?.title, "Spiderman")
    }
}
