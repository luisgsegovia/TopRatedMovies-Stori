//
//  Colors.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 28/07/24.
//

import UIKit

enum Colors {
    static var color0: UIColor { color(named: #function) }
    static var color100: UIColor { color(named: #function) }
    static var color200: UIColor { color(named: #function) }
    static var color300: UIColor { color(named: #function) }
    static var color400: UIColor { color(named: #function) }
    static var color500: UIColor { color(named: #function) }
    static var color600: UIColor { color(named: #function) }
    static var color700: UIColor { color(named: #function) }
    static var color800: UIColor { color(named: #function) }
    static var color900: UIColor { color(named: #function) }

    private static func color(named: String) -> UIColor {
        guard let color = UIColor(named: named) else { return .white }
        return color
    }
}
