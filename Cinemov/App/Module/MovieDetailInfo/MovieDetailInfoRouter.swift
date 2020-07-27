//
//  MovieDetailInfoRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 22/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import UIKit

protocol IMovieDetailInfoRouter: class {
    // do someting...
}

class MovieDetailInfoRouter: IMovieDetailInfoRouter {
    weak var view: MovieDetailInfoViewController?

    init(view: MovieDetailInfoViewController?) {
        self.view = view
    }
}
