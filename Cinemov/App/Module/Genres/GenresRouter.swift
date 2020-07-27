//
//  GenresRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 20/07/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//  MVVM + RxSwift Templates by:  * Febri Adrian
//                                * febriadrian.dev@gmail.com
//                                * https://github.com/febriadrian

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
