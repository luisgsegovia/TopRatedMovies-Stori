//
//  MovieItemCellView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit
import Combine

final class MovieItemCellView: UITableViewCell {
    private(set) var viewModel: ImageViewModel?
    private var subscriptions: Set<AnyCancellable> = .init()

    static let reuseIdentifier = "MovieItemCellView"

    private lazy var movieCardView: MovieItemCardView = {
        let cardView = MovieItemCardView()
        cardView.prepareForAutoLayout()
        cardView._isShimmering = true

        return cardView
    }()

    func configure(with item: MovieItem, viewModel: ImageViewModel) {
        self.viewModel = viewModel

        setUpUI()
        suscribeToState()

        movieCardView.title = item.title
        movieCardView.releaseDate = item.releaseDate
        movieCardView.rating = String(item.voteAverage)

        viewModel.retrieveImage(from: item.posterPath)
    }

    private func setUpUI() {
        contentView.backgroundColor = Colors.color200

        contentView.addSubview(movieCardView)

        NSLayoutConstraint.activate([
            movieCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            movieCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            movieCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func suscribeToState() {
        guard let viewModel else { return }
        viewModel.$state.sink { [weak self] state in
            switch state {
            case .loading:
                self?.setShimmering(to: true)
            case .idle(data: let data):
                self?.setShimmering(to: false)
                self?.setImage(from: data)
            case .placeholder:
                self?.setShimmering(to: true)
                self?.setPlaceholder()

            }

        }.store(in: &subscriptions)
    }

    private func setImage(from data: Data) {
        DispatchQueue.main.async {
            let image = UIImage(data: data)
            self.movieCardView.imageView.setImageAnimated(image)
        }
    }

    private func setPlaceholder() {
        setShimmering(to: false)
    }

    private func setShimmering(to value: Bool) {
        DispatchQueue.main.async {
            self.movieCardView._isShimmering = value
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieCardView.image = nil
        viewModel?.cancel()
    }
}
