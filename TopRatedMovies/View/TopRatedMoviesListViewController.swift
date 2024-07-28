//
//  TopRatedMoviesListViewController.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit
import Combine

class TopRatedMoviesListViewController: UITableViewController {
    private let viewModel: TopRatedMoviesViewModel
    private var subscriptions: Set<AnyCancellable> = .init()

    init(viewModel: TopRatedMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTableView()
        suscribe()
        viewModel.retrieveMovies()

    }

    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieItemCellView.self, forCellReuseIdentifier: MovieItemCellView.reuseIdentifier)
    }

    private func suscribe() {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieItemCellView.reuseIdentifier, for: indexPath) as? MovieItemCellView else { return .init() }
        let info = viewModel.items[indexPath.row]
        cell.configure(with: info)

        return cell
    }

}

