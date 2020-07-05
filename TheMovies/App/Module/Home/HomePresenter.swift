//
//  HomePresenter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IHomePresenter: class {
    func presentGetMovies(response: HomeModel.Response)
    func presentGetMoviesFailed(error: Error?)
}

class HomePresenter: IHomePresenter {
    weak var view: IHomeViewController?

    init(view: IHomeViewController?) {
        self.view = view
    }

    func presentGetMovies(response: HomeModel.Response) {
        if let results = response.results, let page = response.page, let total = response.totalResults {
            var movies = [HomeModel.Movies]()

            for x in results {
                let path = x.posterPath ?? ""
                let posterUrl = API.imgBaseUrl + "w154" + path
                var voteAverage: String?
                if let rating = x.voteAverage, rating != 0 {
                    voteAverage = "\(rating)"
                }

                let movie = HomeModel.Movies(
                    id: x.id ?? 0,
                    title: x.title ?? "n/a",
                    posterUrl: posterUrl,
                    voteAverage: voteAverage ?? "n/a"
                )

                movies.append(movie)
            }

            view?.displayGetMovies(page: page, totalResults: total, movies: movies)
        } else {
            presentGetMoviesFailed(error: nil)
        }
    }

    func presentGetMoviesFailed(error: Error?) {
        var message: String

        if NetworkStatus.isInternetAvailable {
            message = error?.localizedDescription ?? "Unknown Error"
        } else {
            message = "No Internet Connection"
        }

        view?.displayGetMoviesFailed(message: message)
    }
}
