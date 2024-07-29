//
//  TopRatedMoviesListViewController.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit
import Combine

class TopRatedMoviesListViewController: UITableViewController {
    let viewModel: TopRatedMoviesViewModel
    var subscriptions: Set<AnyCancellable> = .init()

    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.prepareForAutoLayout()
        spinner.color = Colors.color0
        spinner.hidesWhenStopped = true

        return spinner
    }()

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
        subscribeToUIState()
        setUpNavBar()
        setUpUI()
        viewModel.retrieveMovies()
    }

    private func prepareTableView() {
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieItemCellView.self, forCellReuseIdentifier: MovieItemCellView.reuseIdentifier)

        tableView.backgroundColor = Colors.color100
    }

    private func setUpNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Colors.color200
        let navBar = navigationController?.navigationBar
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance

        let titleView = UILabel()
        titleView.prepareForAutoLayout()
        titleView.text = "Top Rated Movies"
        titleView.font = Fonts.title
        titleView.textColor = Colors.color900

        navigationItem.titleView = titleView

    }

    private func setUpUI() {
        tableView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
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
        cell.configure(with: info, viewModel: createViewModel())

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.row]
        let viewController = MovieDetailViewController(viewModel: createViewModel(), item: item)
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.items.count - 1 {
            viewModel.retrieveNextPage()
        }
    }

    private func createViewModel() -> ImageViewModel {
        let client = URLSessionHTTPClient(session: .init(configuration: .ephemeral))
        let imageLoader = MovieImageLoader(client: client)
        return ImageViewModel(imageLoader: imageLoader)
    }

}

