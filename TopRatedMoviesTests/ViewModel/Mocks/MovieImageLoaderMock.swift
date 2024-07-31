//
//  MovieImageLoaderMock.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 30/07/24.
//

import Foundation
@testable import TopRatedMovies

class MovieImageLoaderMock: MovieImageLoaderProtocol {
    let task: Task<Data, any Error>

    init(task: Task<Data, any Error>) {
        self.task = task
    }

    func retrieveImage(from path: String) async -> Task<Data, any Error> {
        return task
    }
}
