//
//  MovieDetailRouter.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IMovieDetailRouter: class {
    func navToMovieDetail(id: Int)
}

class MovieDetailRouter: IMovieDetailRouter {
    weak var view: MovieDetailViewController?

    init(view: MovieDetailViewController?) {
        self.view = view
    }
    
    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }
}
