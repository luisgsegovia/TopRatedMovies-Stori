//
//  ImageViewModel.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

final class ImageViewModel {
    private let imageLoader: MovieImageLoaderProtocol
    private var task: Task<Data, Error>?

    @Published var state: State = .loading

    init(imageLoader: any MovieImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }

    func retrieveImage(from path: String) {
        state = .loading
        Task {
            let task = await imageLoader.retrieveImage(from: path)
            self.task = task
            let result = await task.result

            switch result {
            case .success(let data):
                state = .idle(data: data)
            case .failure(let failure):
                state = .placeholder
            }
        }
    }

    func cancel() {
        guard let task = self.task,
        !task.isCancelled else { return }

        task.cancel()
    }
}

extension ImageViewModel {
    enum State: Equatable {
        case loading
        case idle(data: Data)
        case placeholder
    }
}
