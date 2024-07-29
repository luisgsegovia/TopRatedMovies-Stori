//
//  PrimaryButton.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 29/07/24.
//

import UIKit

final class PrimaryButton: UIButton {
    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = bounds.height
        layer.cornerRadius = height/2
    }

    private func setUp() {
        backgroundColor = Colors.color800
        setTitleColor(Colors.color100, for: .normal)
        setTitle(title, for: .normal)
        titleLabel?.font = Fonts.medium
        setImage(UIImage(systemName: "star.fill")?
            .withTintColor(Colors.color100, renderingMode: .alwaysOriginal), for: .normal)
    }
}
