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
                spinner.startAnimating()
            case .idle:
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.tableView.reloadData()
                }
            case .error:
                spinner.stopAnimating()
            }
        }.store(in: &subscriptions)
    }
}
