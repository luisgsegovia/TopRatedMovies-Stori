//
//  MovieItemCellView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit

final class MovieItemCellView: UITableViewCell {
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

    func configure(with item: MovieItem) {
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        contentView.addSubview(stackView)

        let imageLoader = MovieImageLoader(client: URLSessionHTTPClient(session: .shared))
        titleLabel.text = item.title
        subtitleLabel.text = item.releaseDate

        Task {
            let result = await imageLoader.retrieveImage(from: item.posterPath).result

            switch result {
            case .success(let response):
                image.image = UIImage.init(data: response)
            case .failure(let failure):
                image.image = nil
            }
        }
    }
}
