//
//  HomePresenter.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IHomePresenter: class {
    // do someting...
}

class HomePresenter: IHomePresenter {
    weak var view: IHomeViewController?

    init(view: IHomeViewController?) {
        self.view = view
    }
}