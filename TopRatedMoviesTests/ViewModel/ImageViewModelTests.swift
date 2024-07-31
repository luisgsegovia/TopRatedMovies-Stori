//
//  ImageViewModelTests.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 30/07/24.
//

import Combine
import XCTest
@testable import TopRatedMovies

final class ImageViewModelTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable>!

    override func setUp() {
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDown() {
        subscriptions = nil
    }

    func testDataReturnsCorrectly() {
        let data = "Data".data(using: .utf8)!
        let task = createValidTask(with: data)
        let sut = makeSUT(with: task)
        let exp = expectation(description: "Waiting for expectation to finish")

        match(states: [.loading, .idle(data: data)], sut: sut) {
            exp.fulfill()
        }

        sut.retrieveImage(from: "")

        wait(for: [exp], timeout: 1)
    }

    func testClientReturnsErrorAndStatesPlaceholder() {
        let task = createTaskWithError()
        let sut = makeSUT(with: task)
        let exp = expectation(description: "Waiting for expectation to finish")

        match(states: [.loading, .placeholder], sut: sut) {
            exp.fulfill()
        }

        sut.retrieveImage(from: "")

        wait(for: [exp], timeout: 1)
    }

    private func makeSUT(with task: Task<Data, any Error>) -> ImageViewModel {
        return .init(imageLoader: MovieImageLoaderMock(task: task))
    }

    private func createValidTask(with data: Data) -> Task<Data, any Error> {
        Task {
            if !data.isEmpty {
                return data
            } else {
                throw MovieImageLoader.InvalidDataRepresentation()
            }
        }
    }

    private func createTaskWithError() -> Task<Data, any Error> {
        Task {
            let data = Data()
            if !data.isEmpty {
                return data
            } else {
                throw MovieImageLoader.InvalidDataRepresentation()
            }
        }
    }

    private func match(states: [ImageViewModel.State], sut: ImageViewModel, finished: @escaping() -> Void) {
        var allStates = states
        sut.$state
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
