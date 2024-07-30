//
//  TopRatedMoviesLoaderTests.swift
//  TopRatedMoviesTests
//
//  Created by Luis Segovia on 27/07/24.
//

import XCTest
@testable import TopRatedMovies

final class TopRatedMoviesLoaderTests: XCTestCase {
    func testServiceReturnsDataCorrectly() async {
        let (sut, client) = makeSUT()
        client.complete(withStatusCode: 200, data: makeResponse())

        Task { @MainActor in
            let result = await sut.retrieveMovies(page: 1)
            XCTAssertEqual(result, .success(makeExpectedSuccessfulResponse()))
        }
    }

    func testServiceReturnsDataIncorrectly() async {
        let (sut, client) = makeSUT()
        client.complete(withStatusCode: 200, data: makeResponse())
        let jsonData = "".data(using: .utf8)

        Task {
            let result = await sut.retrieveMovies(page: 1)
            XCTAssertEqual(result, .failure(.invalidData))
        }
    }

    func testServiceReturnsNoConnetivityError() async {
        let (sut, client) = makeSUT()
        client.complete(with: TopRatedMoviesLoaderError.connectivity)

        Task {
            let result = await sut.retrieveMovies(page: 1)
            XCTAssertEqual(result, .failure(.connectivity))
        }
    }


    private func makeSUT() -> (sut: TopRatedMoviesLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()

        return (.init(client: client), client)
    }

    

    private func makeResponse() -> Data {
        let jsonString =  "{\"page\":1,\"results\":[{\"adult\":false,\"backdrop_path\":\"/tmU7GeKVybMWFButWEGl2M4GeiP.jpg\",\"genre_ids\":[18,80],\"id\":238,\"original_language\":\"en\",\"original_title\":\"TheGodfather\",\"overview\":\"Spanningtheyears1945to1955,achronicleofthefictionalItalian-AmericanCorleonecrimefamily.Whenorganizedcrimefamilypatriarch,VitoCorleonebarelysurvivesanattemptonhislife,hisyoungestson,Michaelstepsintotakecareofthewould-bekillers,launchingacampaignofbloodyrevenge.\",\"popularity\":100.932,\"poster_path\":\"/3bhkrj58Vtu7enYsRolD1fZdja1.jpg\",\"release_date\":\"1972-03-14\",\"title\":\"TheGodfather\",\"video\":false,\"vote_average\":8.7,\"vote_count\":17806}]},\"total_pages\":552,\"total_results\":11032}"

        let data: Data? = jsonString.data(using: .utf8)
        return data ?? .init()
    }

    private func makeExpectedSuccessfulResponse() -> MovieItems {
        let movieItem = MovieItem(
            id: 238,
            title: "TheGodfather",
            overview: "Spanningtheyears1945to1955,achronicleofthefictionalItalian-AmericanCorleonecrimefamily.Whenorganizedcrimefamilypatriarch,VitoCorleonebarelysurvivesanattemptonhislife,hisyoungestson,Michaelstepsintotakecareofthewould-bekillers,launchingacampaignofbloodyrevenge.",
            releaseDate: "1972-03-14",
            voteAverage: 8.7,
            imagePath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
            posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg")
        let movieItems = MovieItems(items: [movieItem], hasMoreData: true)
        return movieItems
    }
}
