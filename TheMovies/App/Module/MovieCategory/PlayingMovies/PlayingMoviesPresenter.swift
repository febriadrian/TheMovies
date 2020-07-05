//
//  PlayingMoviesPresenter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPlayingMoviesPresenter: class {
    // do someting...
}

class PlayingMoviesPresenter: IPlayingMoviesPresenter {
    weak var view: IPlayingMoviesViewController?

    init(view: IPlayingMoviesViewController?) {
        self.view = view
    }
}
