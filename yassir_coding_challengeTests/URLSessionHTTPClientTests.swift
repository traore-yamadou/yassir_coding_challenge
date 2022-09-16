//
//  yassir_coding_challengeTests.swift
//  yassir_coding_challengeTests
//
//  Created by Yamadou Traore on 16/09/2022.
//

import XCTest
@testable import yassir_coding_challenge

class URLSessionHTTPlientTests: XCTestCase {

    var sut: HTTPClient!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSessionHTTPClient()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testBuildUrlReturnsValidUrlComponents() {
        // Given
        let movieApi = MovieAPI.getMovies(page: 1)

        // When
        let components = sut.buildURL(endpoint: movieApi)

        // Then
        XCTAssertEqual(components.scheme, movieApi.scheme.rawValue)
        XCTAssertEqual(components.host, movieApi.baseURL)
        XCTAssertEqual(components.path, movieApi.path)
        XCTAssertEqual(components.queryItems, movieApi.parameters)
    }

    func testGetFromURLSucceedsWhenDataIsReturned() {
        URLProtocolStub.startInterceptingRequests()
        // Given
        guard let url = URL(string: "http://any-url.com") else {
            XCTFail("URL creation error")
            return
        }

        let data = "[0]".data(using: .utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        URLProtocolStub.stub(data: data, response: response)
        let promise = expectation(description: "Wait for completion")

        // When
        sut.get(from: url) { result in
            switch result {
            case .success((let receivedResponse, let receivedData)):
                // Then
                XCTAssertEqual(data, receivedData)
                XCTAssertEqual(receivedResponse.statusCode, 200)
                XCTAssertEqual(receivedResponse.url, url)
            default:
                XCTFail("Promise failure")
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()

    }

    func testGetFromURLFailsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        // Given
        guard let url = URL(string: "http://any-url.com") else {
            XCTFail("URL creation error")
            return
        }

        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)
        let promise = expectation(description: "Wait for completion")

        // When
        sut.get(from: url) { result in
            switch result {
            case .failure(let receivedError as NSError):
                // Then
                XCTAssertEqual(receivedError.domain, error.domain)
                XCTAssertEqual(receivedError.code, error.code)
            default:
                XCTFail("Promise failure with error \(error) got")
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 1.0)
        URLProtocolStub.stopInterceptingRequests()

    }

    // MARK: - Helpers
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?

        // swiftlint:disable nesting
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}

        // MARK: - Helper
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
        }
    }
}
