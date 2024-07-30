//
//  MovieImageLoader.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

protocol MovieImageLoaderProtocol {
    func retrieveImage(from path: String) async -> Task<Data, Error>
}

final class MovieImageLoader: MovieImageLoaderProtocol {
    private let client: HTTPClient
    private let baseUrl = "https://image.tmdb.org/t/p/w500"

    internal init(client: any HTTPClient) {
        self.client = client
    }

    struct InvalidDataRepresentation: Error {}

    func retrieveImage(from path: String) async -> Task<Data, Error> {
        let request = generateRequest(with: path)

        return Task {
            let result = await client.get(from: request).result
            switch result {
            case .success(let response):
                let data = response.0
                let httpResponse = response.1
                if httpResponse.statusCode == 200 && !data.isEmpty {
                    return data
                } else {
                    throw InvalidDataRepresentation()
                }
            case .failure(let error):
                throw error
            }
        }
    }

    private func generateRequest(with path: String) -> URLRequest {
        let url = URL(string: baseUrl + path)!
        return URLRequest(url: url)
    }
}
