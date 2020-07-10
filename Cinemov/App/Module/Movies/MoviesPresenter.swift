//
//  MoviesPresenter.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMoviesPresenter: class {
    func presentGetMovies(response: MoviesModel.Response)
    func presentGetMoviesFailed(error: Error?)
    func presentUpdateFavorite(movies: [MoviesModel.ViewModel])
}

class MoviesPresenter: IMoviesPresenter {
    weak var view: IMoviesViewController?

    init(view: IMoviesViewController?) {
        self.view = view
    }

    func presentGetMovies(response: MoviesModel.Response) {
        if let results = response.results, let page = response.page, let total = response.totalResults {
            var movies = [MoviesModel.ViewModel]()

            for x in results {
                let path = x.posterPath ?? ""
                let posterUrl = ImageUrl.poster + path

                var voteAverage: String?
                var date: String?
                var favorite: Bool?

                if let rating = x.voteAverage, rating != 0 {
                    voteAverage = "\(rating)"
                }

                if let release = x.releaseDate {
                    date = Helper.dateFormatter(release)
                }

                if let id = x.id {
                    favorite = FavoriteDB.share.checkIsFavorite(id: id)
                }

                let movie = MoviesModel.ViewModel(
                    id: x.id ?? 0,
                    title: x.title ?? "n/a",
                    posterUrl: posterUrl,
                    voteAverage: voteAverage ?? "n/a",
                    overview: x.overview ?? "",
                    releaseDate: date ?? "n/a",
                    favorite: favorite ?? false,
                    createdAt: 0
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

    func presentUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        var newMovies = [MoviesModel.ViewModel]()

        for x in movies {
            let favorite = FavoriteDB.share.checkIsFavorite(id: x.id)

            let movie = MoviesModel.ViewModel(
                id: x.id,
                title: x.title,
                posterUrl: x.posterUrl,
                voteAverage: x.voteAverage,
                overview: x.overview,
                releaseDate: x.releaseDate,
                favorite: favorite,
                createdAt: x.createdAt
            )

            newMovies.append(movie)
        }

        view?.displayUpdateFavorite(movies: newMovies)
    }
}
