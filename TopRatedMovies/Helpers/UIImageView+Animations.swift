//
//  UIImageView+Animations.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 28/07/24.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage

        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}

