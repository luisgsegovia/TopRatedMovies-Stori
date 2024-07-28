//
//  MovieItemMapper.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

final class MovieItemMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [MovieItem] {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(TopRatedMoviesServiceResponse.self, from: data) else {
            throw TopRatedMoviesLoaderError.invalidData
        }

        return root.results.map(map)
    }

    private static func map(_ item: MovieResult) -> MovieItem {
        return .init(
            id: item.id,
            title: item.originalTitle,
            overview: item.overview,
            releaseDate: item.releaseDate,
            voteAverage: item.voteAverage,
            imagePath: item.backdropPath,
            posterPath: item.posterPath
        )
    }
}
