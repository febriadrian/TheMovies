//
//  UpcomingMoviesInteractor.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IUpcomingMoviesInteractor: class {
    var parameters: [String: Any]? { get set }
}

class UpcomingMoviesInteractor: IUpcomingMoviesInteractor {
    var presenter: IUpcomingMoviesPresenter?
    var manager: IUpcomingMoviesManager?
    var parameters: [String: Any]?

    init(presenter: IUpcomingMoviesPresenter, manager: IUpcomingMoviesManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
