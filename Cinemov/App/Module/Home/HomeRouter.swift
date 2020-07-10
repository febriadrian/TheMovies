//
//  HomeRouter.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IHomeRouter: class {
    // do someting...
}

class HomeRouter: IHomeRouter {
    weak var view: HomeViewController?

    init(view: HomeViewController?) {
        self.view = view
    }
}
