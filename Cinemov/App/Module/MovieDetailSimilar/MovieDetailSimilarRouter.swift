//
//  MovieDetailSimilarRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 26/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

import UIKit

protocol IMovieDetailSimilarRouter: class {
    func navToMovieDetail(id: Int)
}

class MovieDetailSimilarRouter: IMovieDetailSimilarRouter {
    weak var view: MovieDetailSimilarViewController?

    init(view: MovieDetailSimilarViewController?) {
        self.view = view
    }

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }
}
