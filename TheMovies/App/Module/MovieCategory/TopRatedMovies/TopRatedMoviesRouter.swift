//
//  TopRatedMoviesRouter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol ITopRatedMoviesRouter: class {
    func navToMovieDetail(id: Int, title: String)
}

class TopRatedMoviesRouter: ITopRatedMoviesRouter {
    weak var view: TopRatedMoviesViewController?

    init(view: TopRatedMoviesViewController?) {
        self.view = view
    }
    
    func navToMovieDetail(id: Int, title: String) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id,
            "movieTitle": title
        ]), completion: nil)
    }
}
