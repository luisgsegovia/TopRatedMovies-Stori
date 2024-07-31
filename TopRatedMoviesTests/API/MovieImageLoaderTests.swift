//
//  MovieImageLoaderTests.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 30/07/24.
//

import XCTest
@testable import TopRatedMovies

final class MovieImageLoaderTests: XCTestCase {
    func testServiceReturnsDataCorrectly() async {
        let (sut, client) = makeSUT()
        let data = "imageData".data(using: .utf8)
        client.complete(withStatusCode: 200, data: data ?? .init())

        Task {
            let result = await sut.retrieveImage(from: "").result
            let retrievedData = try? result.get()
            XCTAssertEqual(retrievedData, data)
        }
    }

    func testServiceReturnsErrorOnClientError() async {
        let (sut, client) = makeSUT()
        let error = NSError(domain: "any error", code: 0)
        client.complete(with: error)

        Task {
            let result = await sut.retrieveImage(from: "").result
            
            switch result {
            case .success:
                XCTFail("Expected an error")
            case .failure(let receivedError):
                XCTAssertEqual(receivedError as NSError, error)
            }
        }
    }

    private func makeSUT() -> (sut: MovieImageLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()

        return (.init(client: client), client)
    }
}
