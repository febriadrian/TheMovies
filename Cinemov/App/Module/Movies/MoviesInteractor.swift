//
//  MoviesInteractor.swift
//  Cinemov
//
//  Created by Febri Adrian on 10/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMoviesInteractor: class {
    var parameters: [String: Any]? { get set }

    func getMovies(category: MovieCategory, page: Int?)
    func updateFavorite(movies: [MoviesModel.ViewModel])
}

class MoviesInteractor: IMoviesInteractor {
    var presenter: IMoviesPresenter?
    var manager: IMoviesManager?
    var parameters: [String: Any]?

    init(presenter: IMoviesPresenter, manager: IMoviesManager) {
        self.presenter = presenter
        self.manager = manager
    }

    func getMovies(category: MovieCategory, page: Int?) {
        manager?.getMovies(category: category, page: page, success: { response in
            let _response = MoviesModel.Response(data: response)
            self.presenter?.presentGetMovies(response: _response)
        }, failure: { error in
            self.presenter?.presentGetMoviesFailed(error: error)
        })
    }

    func updateFavorite(movies: [MoviesModel.ViewModel]) {
        presenter?.presentUpdateFavorite(movies: movies)
    }
}
