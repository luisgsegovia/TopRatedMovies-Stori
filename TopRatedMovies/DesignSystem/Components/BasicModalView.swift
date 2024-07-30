//
//  BasicModalView.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 29/07/24.
//

import UIKit

final class BasicModalView: UIView {
    let title: String
    let subtitle: String
    let action: () -> Void

    private lazy var containerView: UIView = {
        let view = UIView()
        view.prepareForAutoLayout()
        view.layer.cornerRadius = 8
        view.backgroundColor = Colors.color200

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = Fonts.title
        label.textColor = Colors.color900
        label.text = title
        label.numberOfLines = .zero
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)

        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.font = Fonts.big
        label.textColor = Colors.color800
        label.text = subtitle
        label.numberOfLines = .zero
        label.textAlignment = .center

        return label
    }()

    private lazy var okButton: PrimaryButton = {
        let button = PrimaryButton(title: " Okay")
        button.prepareForAutoLayout()
        button.setImage(UIImage(systemName: "checkmark.circle.fill")?
            .withTintColor(Colors.color100, renderingMode: .alwaysOriginal), for: .normal)

        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, okButton])
        stackView.prepareForAutoLayout()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill

        return stackView
    }()

    init(title: String, subtitle: String, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        super.init(frame: .zero)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpUI() {
        containerView.addSubview(stackView)
        addSubview(containerView)

        okButton.setContentHuggingPriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),

            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),

            okButton.heightAnchor.constraint(equalToConstant: 48),
            okButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5)
        ])

        okButton.addTarget(self, action: #selector(executeAction), for: .touchUpInside)
    }

    @objc private func executeAction() {
        action()
    }
}
