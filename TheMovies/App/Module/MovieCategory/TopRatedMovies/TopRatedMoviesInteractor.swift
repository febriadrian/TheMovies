//
//  TopRatedMoviesInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol ITopRatedMoviesInteractor: class {
    var parameters: [String: Any]? { get set }
}

class TopRatedMoviesInteractor: ITopRatedMoviesInteractor {
    var presenter: ITopRatedMoviesPresenter?
    var manager: ITopRatedMoviesManager?
    var parameters: [String: Any]?

    init(presenter: ITopRatedMoviesPresenter, manager: ITopRatedMoviesManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
