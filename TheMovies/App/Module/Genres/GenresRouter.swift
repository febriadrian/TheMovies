//
//  GenresRouter.swift
//  TheMovies
//
//  Created by Febri Adrian on 03/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IGenresRouter: class {
    // do someting...
}

class GenresRouter: IGenresRouter {
    weak var view: GenresViewController?

    init(view: GenresViewController?) {
        self.view = view
    }
}
