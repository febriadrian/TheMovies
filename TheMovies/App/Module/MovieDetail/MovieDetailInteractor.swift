//
//  MovieDetailInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailInteractor: class {
    var parameters: [String: Any]? { get set }

    func getMovieDetail(id: Int)
}

class MovieDetailInteractor: IMovieDetailInteractor {
    var presenter: IMovieDetailPresenter?
    var manager: IMovieDetailManager?
    var parameters: [String: Any]?

    init(presenter: IMovieDetailPresenter, manager: IMovieDetailManager) {
        self.presenter = presenter
        self.manager = manager
    }

    func getMovieDetail(id: Int) {
        manager?.getMovieDetail(id: id, success: { response in
            let _respone = MovieDetailModel.Response(data: response)
            self.presenter?.presentGetMovieDetail(response: _respone)
        }, failure: { error in
            self.presenter?.presentGetMovieDetailFailed(error: error)
        })
    }
}
