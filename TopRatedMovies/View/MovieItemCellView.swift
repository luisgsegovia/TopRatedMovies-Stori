//
//  MovieItemCellView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit
import Combine

final class MovieItemCellView: UITableViewCell {
    private var viewModel: ImageViewModel?
    private var subscriptions: Set<AnyCancellable> = .init()

    static let reuseIdentifier = "MovieItemCellView"

    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForAutoLayout()

        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()

        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .leading

        return stackView
    }()

    func configure(with item: MovieItem, viewModel: ImageViewModel) {
        self.viewModel = viewModel

        setUpUI()
        suscribeToState()

        titleLabel.text = item.title
        subtitleLabel.text = item.releaseDate

        viewModel.retrieveImage(from: item.posterPath)
    }

    private func setUpUI() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(textStackView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalTo: image.heightAnchor, multiplier: 2.0 / 3.0),
            image.widthAnchor.constraint(equalToConstant: 100),

            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func suscribeToState() {
        guard let viewModel else { return }
        viewModel.$state.sink { [weak self] state in
            switch state {
            case .loading:
                self?.setSkeletonView()
            case .idle(data: let data):
                self?.setImage(from: data)
            case .placeholder:
                self?.setPlaceholder()
            }

        }.store(in: &subscriptions)
    }

    private func setImage(from data: Data) {
        DispatchQueue.main.async {
            self.image.image = UIImage(data: data)
        }
    }

    private func setPlaceholder() {

    }

    private func setSkeletonView() {

    }
}
