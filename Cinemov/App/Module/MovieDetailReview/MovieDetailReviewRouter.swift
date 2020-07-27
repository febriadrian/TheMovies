//
//  MovieDetailReviewRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import UIKit

protocol IMovieDetailReviewRouter: class {
    // do someting...
}

class MovieDetailReviewRouter: IMovieDetailReviewRouter {
    weak var view: MovieDetailReviewViewController?

    init(view: MovieDetailReviewViewController?) {
        self.view = view
    }
}
