//
//  MovieItemCardView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 28/07/24.
//

import UIKit
import Foundation

final class MovieItemCardView: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    var releaseDate: String? {
        didSet {
            releaseDateLabel.text = "Release date: \(String(describing: releaseDate!))"
        }
    }

    var rating: String? {
        didSet {
            ratingLabel.text = "Rating: \(rating!.formatToOneDecimal()) "
        }
    }

    var image: UIImage? {
        didSet {
            imageView.image = image
        }

    }

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color0
        label.numberOfLines = .zero
        label.font = UIFont(name: "AmazonEmber-Bold", size: 20)

        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color100
        label.font = UIFont(name: "AmazonEmber-Medium", size: 15)

        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color100
        label.font = UIFont(name: "AmazonEmber-Medium", size: 15)

        return label
    }()

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.prepareForAutoLayout()
        view.backgroundColor = Colors.color800
        view.layer.cornerRadius = 16

        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()
        stackView.alignment = .center

        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .leading

        return stackView
    }()

    required init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(releaseDateLabel)
        textStackView.addArrangedSubview(ratingLabel)
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(textStackView)
        backgroundView.addSubview(mainStackView)
        addSubview(backgroundView)

        textStackView.setCustomSpacing(24, after: titleLabel)
        mainStackView.setCustomSpacing(8, after: imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 2.0 / 3.0),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -8), //

            mainStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 0),
            mainStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 0),

            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }

    private func format(_ value: String) -> String {
        guard let number = Double(value) else { return "" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        guard let number =  numberFormatter.string(from: NSNumber(value: number)) else { fatalError("Can not get number") }
        return number
    }
}
