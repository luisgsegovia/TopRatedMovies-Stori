//
//  PaginationData.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

class PaginationData {
    init(page: Int = 1, canLoadMore: Bool = true) {
        self.page = page
        self.canLoadMore = canLoadMore
    }
    
    private(set) var page: Int
    private(set) var canLoadMore: Bool

    func increment() {
        page += 1
    }

    func reset() {
        page = 1
    }

    func setFlag(to value: Bool) {
        canLoadMore = value
    }
}
