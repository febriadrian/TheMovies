//
//  PopularMoviesInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IPopularMoviesInteractor: class {
    var parameters: [String: Any]? { get set }
}

class PopularMoviesInteractor: IPopularMoviesInteractor {
    var presenter: IPopularMoviesPresenter?
    var manager: IPopularMoviesManager?
    var parameters: [String: Any]?

    init(presenter: IPopularMoviesPresenter, manager: IPopularMoviesManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
