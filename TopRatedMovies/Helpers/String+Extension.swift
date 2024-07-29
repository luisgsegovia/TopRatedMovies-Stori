//
//  String+Extension.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 29/07/24.
//

import Foundation

extension String {
    func formatToOneDecimal() -> String {
        guard let number = Double(self) else { return "" }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        guard let number =  numberFormatter.string(from: NSNumber(value: number)) else { fatalError("Can not get number") }
        return number
    }
}
