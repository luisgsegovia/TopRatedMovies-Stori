//
//  ViewController.swift
//  TopRatedMovies
//
//  Created by Luis Segovia on 27/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        Task {
            await loadMovies()
        }
    }

    private func loadMovies() async {
        let loader = TopRatedMoviesLoader(client: URLSessionHTTPClient(session: .shared))
        let result = await loader.retrieveMovies(page: 1)

        switch result {
        case .success(let success):
            print(success.items)
            print(success.hasMoreData)
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }


}

