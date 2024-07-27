//
//  URLSessionHTTPClient.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(from urlRequest: URLRequest) async -> Task<(Data, HTTPURLResponse), Error> {
        return Task {
            do {
                let result = try await session.data(for: urlRequest)
                if let response = result.1 as? HTTPURLResponse {
                    return (result.0, response)
                } else {
                    throw UnexpectedValuesRepresentation()
                }
            } catch {
                throw error
            }
        }
    }
}
