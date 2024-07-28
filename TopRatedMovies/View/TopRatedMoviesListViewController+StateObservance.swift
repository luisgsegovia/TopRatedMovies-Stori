//
//  TopRatedMoviesListViewController+StateObservance.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation
import Combine

extension TopRatedMoviesListViewController {
    func subscribeToUIState() {
        viewModel.$uiState.sink { [weak self] state in
            guard let self else { return }

            switch state {
            case .loading:
                break
            case .idle:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .error:
                break
            }
        }.store(in: &subscriptions)
    }
}
