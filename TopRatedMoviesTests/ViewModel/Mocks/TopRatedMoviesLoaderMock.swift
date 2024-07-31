//
//  TopRatedMoviesLoaderMock.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 30/07/24.
//

@testable import TopRatedMovies

class TopRatedMoviesLoaderMock: TopRatedMoviesLoaderProtocol {
    private let result: Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError>

    init(result: Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError>) {
        self.result = result
    }

    func retrieveMovies(page: Int) async -> Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError> {
        return result
    }
}
