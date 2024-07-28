//
//  TopRatedMoviesViewModel.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

final class TopRatedMoviesViewModel {
    private let moviesLoader: TopRatedMoviesLoaderProtocol
    private var pagination = PaginationData()

    var items: [MovieItem] = []

    @Published var uiState: UIState = .loading

    init(moviesLoader: TopRatedMoviesLoaderProtocol) {
        self.moviesLoader = moviesLoader
    }

    func retrieveMovies() {
        guard pagination.canLoadMore else { return }

        uiState = .loading
        Task {
            let result = await moviesLoader.retrieveMovies(page: pagination.page)

            switch result {
            case .success(let response):
                handleSucces(with: response)
            case .failure(let failure):
                handleError()
            }
        }
    }

    private func handleSucces(with response: MovieItems) {
        self.items += response.items
        pagination.setFlag(to: response.hasMoreData)
        uiState = .idle
    }

    private func handleError() {
        uiState = .error
    }
}

extension TopRatedMoviesViewModel {
    enum UIState: Equatable {
        case loading
        case idle
        case error
    }
}
