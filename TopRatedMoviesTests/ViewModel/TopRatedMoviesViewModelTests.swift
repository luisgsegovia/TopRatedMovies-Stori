//
//  TopRatedMoviesViewModelTests.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 30/07/24.
//

import XCTest
import Combine
@testable import TopRatedMovies

final class TopRatedMoviesViewModelTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDown() {
        subscriptions = nil
    }

    func testRetrieveMoviesReturnsSuccessfulResult() {
        let sut = makeSUT(withResult: .success(createMovieItems()))
        let exp = expectation(description: "Waiting for expectation to finish")

        match(states: [.loading, .idle], sut: sut) {
            exp.fulfill()
        }

        sut.retrieveMovies()

        wait(for: [exp], timeout: 1)
    }

    func testRetrieveMoviesReturnsFailureResult() {
        let sut = makeSUT(withResult: .failure(.invalidData))
        let exp = expectation(description: "Waiting for expectation to finish")

        match(states: [.loading, .error], sut: sut) {
            exp.fulfill()
        }

        sut.retrieveMovies()

        wait(for: [exp], timeout: 1)
    }

    func testRetrieveMoviesNextPageAndThereAreMorePages() {
        let sut = makeSUT(withResult: .success(createMovieItems()), pagination: .init(canLoadMore: true))
        let exp = expectation(description: "Waiting for expectation to finish")

        match(paginationStates: [.loading, .idle], sut: sut) {
            exp.fulfill()
        }

        sut.retrieveNextPage()

        wait(for: [exp], timeout: 1)
    }

    func testRetrieveMoviesNextPageButThereAreNoMorePages() {
        let sut = makeSUT(withResult: .success(createMovieItems()), pagination: .init(canLoadMore: false))

        sut.retrieveNextPage()

        XCTAssertEqual(sut.paginationState, .idle)
    }

    private func makeSUT(withResult result: Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError>, pagination: PaginationData = .init()) -> TopRatedMoviesViewModel {
        let moviesLoader = TopRatedMoviesLoaderMock(result: result)
        return .init(moviesLoader: moviesLoader, pagination: pagination)
    }

    private func createMovieItems() -> MovieItems {
        .init(items: [], hasMoreData: true)
    }

    private func match(states: [TopRatedMoviesViewModel.UIState], sut: TopRatedMoviesViewModel, finished: @escaping() -> Void) {
        var allStates = states
        sut.$uiState
            .dropFirst()
            .sink(receiveValue: { state in
                if let expectedState = allStates.first {
                    allStates.remove(at: .zero)
                    XCTAssertEqual(expectedState, state)
                }

                if allStates.isEmpty { finished() }
            })
            .store(in: &subscriptions)
    }

    private func match(paginationStates: [TopRatedMoviesViewModel.PaginationState], sut: TopRatedMoviesViewModel, finished: @escaping() -> Void) {
        var allStates = paginationStates
        sut.$paginationState
            .dropFirst()
            .sink(receiveValue: { state in
                if let expectedState = allStates.first {
                    allStates.remove(at: .zero)
                    XCTAssertEqual(expectedState, state)
                }

                if allStates.isEmpty { finished() }
            })
            .store(in: &subscriptions)
    }
}

class TopRatedMoviesLoaderMock: TopRatedMoviesLoaderProtocol {
    private let result: Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError>
    
    init(result: Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError>) {
        self.result = result
    }

    func retrieveMovies(page: Int) async -> Result<TopRatedMovies.MovieItems, TopRatedMovies.TopRatedMoviesLoaderError> {
        return result
    }
    

}
