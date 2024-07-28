//
//  HTTPClientSpy.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation
import TopRatedMovies

class HTTPClientSpy: HTTPClient {
    private var task: Task<(Data, HTTPURLResponse), Error>?

    func get(from urlRequest: URLRequest) async -> Task<(Data, HTTPURLResponse), any Error> {
        return task!
    }
    func complete(with error: Error) {
        task = Task {
            throw error
        }
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        task = Task {
            let response = HTTPURLResponse(
                url: URL(string: "https://a-url.com")!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            return (data, response)
        }
//        let response = HTTPURLResponse(
//            url: requestedURLs[index],
//            statusCode: code,
//            httpVersion: nil,
//            headerFields: nil
//        )!
//        messages[index].completion(.success((data, response)))
    }
}
