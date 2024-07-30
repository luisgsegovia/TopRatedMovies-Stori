//
//  ModalPresentationViewController.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 29/07/24.
//

import UIKit

final class ModalPresentationViewController: UIViewController {
    private lazy var modalView: BasicModalView = {
        let view = BasicModalView(
            title: "Hurray!",
            subtitle: "Movie added to favorites!",
            action: dismiss)
        view.prepareForAutoLayout()

        return view
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    private func setUpUI() {
        view.backgroundColor = .black.withAlphaComponent(0.5)

        view.addSubview(modalView)

        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            modalView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25)
        ])
    }

    private func dismiss() {
        dismiss(animated: true)
    }
}
