//
//  TopRatedMoviesLoader.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

protocol TopRatedMoviesLoaderProtocol {
    func retrieveMovies(page: Int) async -> Result<MovieItems, TopRatedMoviesLoaderError>
}

final class TopRatedMoviesLoader: TopRatedMoviesLoaderProtocol {
    private let client: HTTPClient
    private let url = URL(string: Endpoint.url)!

    init(client: HTTPClient) {
        self.client = client
    }

    func retrieveMovies(page: Int) async -> Result<MovieItems, TopRatedMoviesLoaderError> {
        let request = generateRequest(with: page)

        let result = await client.get(from: request).result

        switch result {
        case .success(let response):
            do {
                return try .success(MovieItemsMapper.map(response.0, from: response.1, page: page))
            } catch {
                return .failure(.invalidData)
            }
        case .failure:
            return .failure(.connectivity)
        }
    }

    private func generateRequest(with page: Int) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: String(page)),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = Endpoint.httpMethod
        request.timeoutInterval = Endpoint.timeoutInterval
        request.allHTTPHeaderFields = Endpoint.httpHeaders

        return request
    }

    enum Endpoint {
        static let url = "https://api.themoviedb.org/3/movie/top_rated"
        static let timeoutInterval: Double = 10
        static let httpMethod = "GET"
        static let httpHeaders = [
            "accept": "application/json",
            "Authorization": "Bearer \(APIConstants.token)"
        ]
    }
}

