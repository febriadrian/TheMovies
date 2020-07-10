//
//  HomeInteractor.swift
//  Cinemov
//
//  Created by Febri Adrian on 08/07/20.
//  Copyright (c) 2020 Febri Adrian. All rights reserved.
//  Modified VIP Templates by:  * Febri Adrian
//                              * febriadrian.dev@gmail.com
//                              * https://github.com/febriadrian

import UIKit

protocol IHomeInteractor: class {
    var parameters: [String: Any]? { get set }
}

class HomeInteractor: IHomeInteractor {
    var presenter: IHomePresenter?
    var manager: IHomeManager?
    var parameters: [String: Any]?

    init(presenter: IHomePresenter, manager: IHomeManager) {
        self.presenter = presenter
        self.manager = manager
    }
}
