//
//  FavoriteRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IFavoriteRouter: class {
    func navToMovieDetail(id: Int)
}

class FavoriteRouter: IFavoriteRouter {
    weak var view: FavoriteViewController?

    init(view: FavoriteViewController?) {
        self.view = view
    }

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }
}
