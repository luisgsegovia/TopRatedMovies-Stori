//
//  TopRatedMoviesLoader.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

protocol TopRatedMoviesLoaderProtocol {
    func retrieveMovies(page: Int) async -> Result<[MovieItem], TopRatedMoviesLoaderError>
}

final class TopRatedMoviesLoader: TopRatedMoviesLoaderProtocol {
    init(client: HTTPClient) {
        self.client = client
    }

    private let client: HTTPClient
    private let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated")!

    func retrieveMovies(page: Int) async -> Result<[MovieItem], TopRatedMoviesLoaderError> {
        let request = generateRequest(with: page)

        let result = await client.get(from: request).result

        switch result {
        case .success(let response):
            print(String(decoding: response.0, as: UTF8.self))
            return .success([])
        case .failure(let error):
            print(error.localizedDescription)
            return .failure(.invalid)
        }
    }

    private func generateRequest(with page: Int) -> URLRequest {
        let urlRequest = URLRequest(url: url)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: String(page)),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZTRlYjU5NzExYTUxNWNmNjA2MmMxOWZlMzk1ODRlZCIsIm5iZiI6MTcyMjAzNDU3Mi4yNTgyNzUsInN1YiI6IjY2YTQyODE5MTljNjI0ZWQ3Zjc2NzdhZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Qd_ZpJkhd0mZxixXiegbuK7NSKyvm7THQTfHJuuykBI"
        ]

        return request
    }
}

