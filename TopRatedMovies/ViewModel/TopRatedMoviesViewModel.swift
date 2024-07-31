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
    @Published var paginationState: PaginationState = .idle

    init(moviesLoader: TopRatedMoviesLoaderProtocol) {
        self.moviesLoader = moviesLoader
    }

    // For Testing purposes
    init(moviesLoader: TopRatedMoviesLoaderProtocol, pagination: PaginationData = .init()) {
        self.moviesLoader = moviesLoader
        self.pagination = pagination
    }

    func retrieveMovies() {
        uiState = .loading
        retrieveNextPage()
    }

    func retrieveNextPage() {
        guard pagination.canLoadMore, paginationState != .loading else { return }
        paginationState = .loading
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
        pagination.increment()
        pagination.setFlag(to: response.hasMoreData)
        uiState = .idle
        paginationState = .idle
    }

    private func handleError() {
        uiState = .error
        paginationState = .error
    }
}

extension TopRatedMoviesViewModel {
    enum UIState: Equatable {
        case loading
        case idle
        case error
    }

    enum PaginationState: Equatable {
        case loading
        case idle
        case error
    }
}
