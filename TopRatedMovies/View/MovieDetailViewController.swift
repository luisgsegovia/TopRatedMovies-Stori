//
//  MovieDetailViewController.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 28/07/24.
//

import UIKit
import Combine

final class MovieDetailViewController: UIViewController {
    let viewModel: ImageViewModel
    let item: MovieItem
    var subscriptions: Set<AnyCancellable> = .init()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.prepareForAutoLayout()
        imageView.contentMode = .scaleAspectFill
        imageView.heightAnchor.constraint(equalToConstant: 300)
            .isActive = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color0
        label.numberOfLines = .zero
        label.font = UIFont(name: "AmazonEmber-Bold", size: 24)
        label.text = item.title

        return label
    }()

    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color100
        label.font = UIFont(name: "AmazonEmber-Medium", size: 18)
        label.text = item.releaseDate

        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = Colors.color100
        label.font = UIFont(name: "AmazonEmber-Medium", size: 18)
        label.text = String(item.voteAverage)

        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()
        stackView.axis = .vertical

        return stackView
    }()

    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()
        stackView.axis = .vertical

        return stackView
    }()

    private lazy var additionalsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.prepareForAutoLayout()

        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.prepareForAutoLayout()
        scrollView.contentInsetAdjustmentBehavior = .never

        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.prepareForAutoLayout()

        return view
    }()

    private lazy var textCardView: TextCardView = {
        let view = TextCardView()
        view.prepareForAutoLayout()
        view.text = item.overview

        return view
    }()

    init(viewModel: ImageViewModel, item: MovieItem) {
        self.viewModel = viewModel
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNavBar()
        suscribeToState()
        getImage()
    }

    private func setUpUI() {
        view.backgroundColor = Colors.color900

        additionalsStackView.addArrangedSubview(releaseDateLabel)
        additionalsStackView.addArrangedSubview(ratingLabel)
        descriptionStackView.addArrangedSubview(titleLabel)
        descriptionStackView.addArrangedSubview(additionalsStackView)
        mainStackView.addArrangedSubview(descriptionStackView)
        mainStackView.addArrangedSubview(textCardView)

        containerView.addSubview(imageView)
        containerView.addSubview(mainStackView)
        scrollView.addSubview(containerView)

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//
            mainStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }

    private func setUpNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        let navBar = navigationController?.navigationBar
        navBar?.standardAppearance = appearance
        navBar?.scrollEdgeAppearance = appearance
    }

    //Hace push a pantalla en negro

    private func getImage() {
        viewModel.retrieveImage(from: item.imagePath)
    }

    private func suscribeToState() {
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
            self.imageView.image = UIImage(data: data)
        }
    }

    private func setPlaceholder() {

    }

    private func setSkeletonView() {
        imageView.setImageAnimated(UIImage())
    }
}
