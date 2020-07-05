//
//  PlayingMoviesInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPlayingMoviesInteractor: class {
    var parameters: [String: Any]? { get set }
}

class PlayingMoviesInteractor: IPlayingMoviesInteractor {
    var presenter: IPlayingMoviesPresenter?
    var manager: IPlayingMoviesManager?
    var parameters: [String: Any]?

    init(presenter: IPlayingMoviesPresenter, manager: IPlayingMoviesManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
