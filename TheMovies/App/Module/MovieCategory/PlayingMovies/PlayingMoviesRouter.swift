//
//  PlayingMoviesRouter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPlayingMoviesRouter: class {
    func navToMovieDetail(id: Int, title: String)
}

class PlayingMoviesRouter: IPlayingMoviesRouter {
    weak var view: PlayingMoviesViewController?

    init(view: PlayingMoviesViewController?) {
        self.view = view
    }

    func navToMovieDetail(id: Int, title: String) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id,
            "movieTitle": title
        ]), completion: nil)
    }
}
