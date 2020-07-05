//
//  TopRatedMoviesPresenter.swift
//  TheMovies
//
//  Created by Febri Adrian on 02/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol ITopRatedMoviesPresenter: class {
    // do someting...
}

class TopRatedMoviesPresenter: ITopRatedMoviesPresenter {
    weak var view: ITopRatedMoviesViewController?

    init(view: ITopRatedMoviesViewController?) {
        self.view = view
    }
}
