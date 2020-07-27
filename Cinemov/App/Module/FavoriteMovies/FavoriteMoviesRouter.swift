//
//  FavoriteMoviesRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol IFavoriteMoviesRouter: class {
    func navToMovieDetail(id: Int)
}

class FavoriteMoviesRouter: IFavoriteMoviesRouter {
    weak var view: FavoriteMoviesViewController?

    init(view: FavoriteMoviesViewController?) {
        self.view = view
    }

    func navToMovieDetail(id: Int) {
        view?.navigate(type: .push, module: GeneralRoute.movieDetail(parameter: [
            "id": id
        ]), completion: nil)
    }
}
