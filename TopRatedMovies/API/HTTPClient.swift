//
//  HTTPClient.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import Foundation

public protocol HTTPClient {
    @discardableResult
    func get(from urlRequest: URLRequest) async -> Task<(Data, HTTPURLResponse), Error>
}


