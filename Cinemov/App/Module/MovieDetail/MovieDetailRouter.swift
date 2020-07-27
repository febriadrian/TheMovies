//
//  MovieDetailRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import UIKit

protocol IMovieDetailRouter: class {
    // do someting...
}

class MovieDetailRouter: IMovieDetailRouter {
    weak var view: MovieDetailViewController?

    init(view: MovieDetailViewController?) {
        self.view = view
    }
}
