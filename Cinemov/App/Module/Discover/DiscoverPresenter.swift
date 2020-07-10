//
//  DiscoverPresenter.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IDiscoverPresenter: class {
    func presentGetDiscoverMovies(response: MoviesModel.Response)
    func presentGetDiscoverMoviesFailed(error: Error?)
}

class DiscoverPresenter: IDiscoverPresenter {
    weak var view: IDiscoverViewController?

    init(view: IDiscoverViewController?) {
        self.view = view
    }

    func presentGetDiscoverMovies(response: MoviesModel.Response) {
        if let results = response.results, let page = response.page, let total = response.totalResults {
            var movies = [MoviesModel.ViewModel]()

            for x in results {
                let path = x.posterPath ?? ""
                let posterUrl = ImageUrl.poster + path
                var voteAverage: String?
                if let rating = x.voteAverage, rating != 0 {
                    voteAverage = "\(rating)"
                }

                let movie = MoviesModel.ViewModel(
                    id: x.id ?? 0,
                    title: "",
                    posterUrl: posterUrl,
                    voteAverage: voteAverage ?? "n/a",
                    overview: "",
                    releaseDate: "",
                    favorite: false,
                    createdAt: 0
                )

                movies.append(movie)
            }

            view?.displayGetDiscoverMovies(page: page, totalResults: total, movies: movies)
        } else {
            presentGetDiscoverMoviesFailed(error: nil)
        }
    }

    func presentGetDiscoverMoviesFailed(error: Error?) {
        var message: String

        if NetworkStatus.isInternetAvailable {
            message = error?.localizedDescription ?? "Unknown Error"
        } else {
            message = "No Internet Connection"
        }

        view?.displayGetDiscoverMoviesFailed(message: message)
    }
}
