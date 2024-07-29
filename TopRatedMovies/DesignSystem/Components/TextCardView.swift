//
//  TextCardView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 29/07/24.
//

import UIKit

final class TextCardView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.prepareForAutoLayout()
        view.backgroundColor = Colors.color300
        view.layer.cornerRadius = 16

        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.numberOfLines = .zero
        label.text = text
        label.textColor = Colors.color800
        label.font = Fonts.medium

        return label
    }()

    var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    init() {
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        addSubview(containerView)
        containerView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
        ])
    }

    
}
